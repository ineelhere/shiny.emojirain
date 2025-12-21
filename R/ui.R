#' Emoji Shower UI Component
#'
#' Creates a festive emoji/image shower animation for R Shiny applications.
#' Emojis or images fall from the top with optional rotation and physics-based movement.
#' Perfect for celebrations, holidays, milestones, and special events!
#'
#' @param emojis Character vector of emoji characters or image URLs to display.
#'        Defaults to Christmas emojis. Use [emoji_presets()] for pre-made collections
#'        or provide your own custom emojis. Supports: Unicode emoji characters
#'        (e.g., "🎉", "🎄"), web image URLs (http://, https://), data URIs,
#'        local file paths, and files with extensions (.jpg, .png, .gif, .webp, .svg).
#'        Emojis will be randomly selected from this vector during animation.
#' @param trigger Character string specifying when to trigger the animation.
#'        Options: "app_load" (automatically triggers on page load) or NULL
#'        (manual trigger only via [emit_shower()] in server). Set to NULL when
#'        you want to control when the shower appears via user interactions.
#' @param duration Numeric. Total duration of the animation in milliseconds.
#'        Controls how long the shower effect lasts before clearing particles.
#'        Recommended range: 2000-10000 (2-10 seconds). Default: 6000 (6 seconds).
#'        Shorter durations create quick bursts; longer durations sustain the effect.
#' @param fall_speed Numeric. Gravity/velocity factor controlling how fast particles fall.
#'        Affects the downward acceleration of emojis during the animation.
#'        Valid range: 0.5-2.5. Default: 1.5. Lower values create slow, elegant falls;
#'        higher values create rapid, dramatic cascades.
#' @param spin_speed Numeric or NULL. Rotation speed in degrees per animation frame.
#'        Controls the spin effect applied to particles. Set to a numeric value
#'        (recommended: 1-5) to enable rotation, or NULL to disable rotation (default).
#'        Higher values create faster spins. Works great with emojis like 💫, ⭐, 🌟.
#' @param particle_count Numeric. Number of emoji/image particles emitted per burst.
#'        More particles create a denser shower effect but use more resources.
#'        Valid range: 5-30. Default: 15. Adjust based on your audience's device capabilities.
#' @param burst_count Numeric. Number of successive bursts in the animation sequence.
#'        A burst is a single emission of particles. Multiple bursts create a more
#'        extended animation effect. Valid range: 1-20. Default: 8.
#'        Bursts are spaced 200ms apart for a natural staggered effect.
#' @param image_size Numeric. Size of images in pixels (applies only to image URLs, not emojis).
#'        Controls the width and height of rendered images. Valid range: 16-256 pixels.
#'        Default: 32. Emoji characters scale automatically; this only affects external images.
#'
#' @return A Shiny tag (head tag) with embedded HTML and JavaScript code
#'        that initializes the emoji shower animation. This is meant to be included
#'        in your Shiny UI definition.
#'
#' @details
#' ## Rendering and Performance
#' The shower is rendered as a fixed overlay (z-index: 9999) that covers the entire
#' viewport without interfering with page interactions (pointer-events: none).
#' All DOM elements are automatically cleaned up after animation completes,
#' ensuring no memory leaks or lingering elements.
#'
#' ## Content Types Supported
#' The function supports three types of content:
#' - **Emojis**: Unicode emoji characters ("🎉", "🎄", "❤️", etc.)
#'   Font size varies between 20-35px for visual variety.
#' - **Web Images**: URLs starting with "http://", "https://", or "data:" URIs.
#'   Perfect for custom branding or special images. Uses the `image_size` parameter.
#' - **Local Files**: Relative or absolute paths to image files (.jpg, .png, .gif,
#'   .webp, .svg). Useful for incorporating assets from your Shiny app's www/ folder.
#'
#' ## Physics
#' Particles start at the top (y = -50) and fall downward with:
#' - Vertical velocity determined by `fall_speed`
#' - Horizontal drift from random velocities (-0.3 to 0.3 per frame)
#' - Optional rotation at the rate specified by `spin_speed`
#' - Automatic respawn when particles exit the bottom of the viewport
#'
#' ## Integration with Server Control
#' For advanced customization, combine with [setup_emoji_handler()] and
#' [emit_shower()] to trigger showers from server-side events.
#'
#' @examples
#' \dontrun{
#' library(shiny)
#' 
#' # Simple usage - auto-trigger on load
#' ui <- fluidPage(
#'   emoji_shower_ui(),
#'   h1("Welcome!")
#' )
#' 
#' # With custom emojis
#' ui <- fluidPage(
#'   emoji_shower_ui(
#'     emojis = emoji_presets()$halloween,
#'     trigger = NULL,
#'     spin_speed = 3
#'   ),
#'   actionButton("trigger", "Halloween Party!")
#' )
#' 
#' # With image URLs
#' ui <- fluidPage(
#'   emoji_shower_ui(
#'     emojis = c(
#'       "https://example.com/star.png",
#'       "https://example.com/heart.gif"
#'     ),
#'     image_size = 48,
#'     trigger = NULL
#'   ),
#'   actionButton("trigger", "Image Shower!")
#' )
#' }
#'
#' @export
emoji_shower_ui <- function(
  emojis = c("\U0001f384", "\U0001f385", "\u26c4", "\U0001f381", "\U0001f514", "\u2728", "\u2744\ufe0f", "\U0001f38a", "\u2b50", "\U0001f31f"),
  trigger = "app_load",
  duration = 6000,
  fall_speed = 1.5,
  spin_speed = NULL,
  particle_count = 15,
  burst_count = 8,
  image_size = 32
) {
  
  # Validate inputs
  if (!is.numeric(duration) || duration < 500) {
    stop("duration must be numeric and >= 500 ms", call. = FALSE)
  }
  
  if (!is.numeric(fall_speed) || fall_speed <= 0) {
    stop("fall_speed must be positive numeric", call. = FALSE)
  }
  
  if (!is.null(spin_speed) && (!is.numeric(spin_speed) || spin_speed <= 0)) {
    stop("spin_speed must be positive numeric or NULL", call. = FALSE)
  }
  
  if (!is.numeric(particle_count) || particle_count < 1) {
    stop("particle_count must be positive numeric", call. = FALSE)
  }
  
  if (!is.numeric(burst_count) || burst_count < 1) {
    stop("burst_count must be positive numeric", call. = FALSE)
  }
  
  if (!is.numeric(image_size) || image_size < 16 || image_size > 256) {
    stop("image_size must be numeric between 16 and 256", call. = FALSE)
  }
  
  # Validate emojis
  validate_emojis(emojis)
  
  # Convert emojis/images to JSON
  emojis_json <- jsonlite::toJSON(emojis)
  
  # Build spin configuration
  spin_config <- if (is.null(spin_speed)) {
    "enableSpin: false"
  } else {
    sprintf("enableSpin: true, spinSpeed: %f", spin_speed)
  }
  
  # Generate JavaScript
  js_code <- .generate_js(
    emojis_json, duration, fall_speed, spin_config,
    particle_count, burst_count, image_size, trigger
  )
  
  html_code <- paste0(
    '<div id="emoji-shower-container" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; z-index: 9999; overflow: hidden;"></div>',
    '<script>(function() { ', js_code, ' })();</script>'
  )
  
  shiny::tags$head(shiny::HTML(html_code))
}

#' @keywords internal
.generate_js <- function(emojis_json, duration, fall_speed, spin_config,
                         particle_count, burst_count, image_size, trigger) {
  paste0(
    'const CONFIG = {',
    'emojis: ', emojis_json, ',',
    'duration: ', duration, ',',
    'fallSpeed: ', fall_speed, ',',
    spin_config, ',',
    'particleCount: ', particle_count, ',',
    'burstCount: ', burst_count, ',',
    'imageSize: ', image_size, ',',
    'trigger: "', (trigger %||% "manual"), '"',
    '};',
    
    'function isImageUrl(str) {',
    '  var pattern = /^(https?:\\/\\/)|(data:image)|(\\.(jpg|jpeg|png|gif|webp|svg))$/i;',
    '  return pattern.test(str);',
    '}',
    
    'function Particle(x, y, content, velocityX, velocityY, range, enableSpin, spinSpeed, imageSize) {',
    '  this.x = x;',
    '  this.y = y;',
    '  this.content = content;',
    '  this.velocityX = velocityX;',
    '  this.velocityY = velocityY;',
    '  this.range = range;',
    '  this.rotation = 0;',
    '  this.enableSpin = enableSpin;',
    '  this.spinSpeed = spinSpeed || 3;',
    '  this.element = document.createElement("div");',
    '  this.element.style.position = "fixed";',
    '  this.element.style.opacity = 1;',
    '  this.element.style.pointerEvents = "none";',
    '  this.element.style.userSelect = "none";',
    '  this.element.style.willChange = "transform";',
    '  if (isImageUrl(content)) {',
    '    var img = document.createElement("img");',
    '    img.src = content;',
    '    img.style.width = imageSize + "px";',
    '    img.style.height = imageSize + "px";',
    '    img.style.objectFit = "contain";',
    '    img.style.display = "block";',
    '    this.element.appendChild(img);',
    '  } else {',
    '    this.element.style.fontSize = (20 + Math.random() * 15) + "px";',
    '    this.element.innerHTML = content;',
    '  }',
    '  document.getElementById("emoji-shower-container").appendChild(this.element);',
    '  this.update();',
    '}',
    
    'Particle.prototype.update = function() {',
    '  this.y += this.velocityY;',
    '  this.x += this.velocityX;',
    '  if (this.enableSpin) {',
    '    this.rotation = (this.rotation + this.spinSpeed) % 360;',
    '  }',
    '  if (this.y > window.innerHeight + 100) {',
    '    this.y = -50;',
    '    this.x = this.range[0] + Math.random() * this.range[1];',
    '  }',
    '  var transform = "translate3d(" + this.x + "px, " + this.y + "px, 0)";',
    '  if (this.enableSpin) {',
    '    transform += " rotate(" + this.rotation + "deg)";',
    '  }',
    '  this.element.style.transform = transform;',
    '};',
    
    'var particles = [];',
    'var animationId = null;',
    
    'function startShower() {',
    '  if (particles.length > 0) {',
    '    particles.forEach(function(p) { p.element.remove(); });',
    '    particles = [];',
    '  }',
    '  var contentList = CONFIG.emojis;',
    '  var range = [0, window.innerWidth];',
    '  for (var burst = 0; burst < CONFIG.burstCount; burst++) {',
    '    setTimeout((function(b) {',
    '      return function() {',
    '        for (var i = 0; i < CONFIG.particleCount; i++) {',
    '          var content = contentList[Math.floor(Math.random() * contentList.length)];',
    '          var x = range[0] + Math.random() * range[1];',
    '          var velocityX = -0.3 + Math.random() * 0.6;',
    '          var velocityY = CONFIG.fallSpeed + Math.random() * CONFIG.fallSpeed * 0.5;',
    '          particles.push(new Particle(x, -50, content, velocityX, velocityY, range, CONFIG.enableSpin, CONFIG.spinSpeed, CONFIG.imageSize));',
    '        }',
    '      };',
    '    })(burst), burst * 200);',
    '  }',
    '  function animate() {',
    '    particles.forEach(function(p) { p.update(); });',
    '    animationId = requestAnimationFrame(animate);',
    '  }',
    '  animate();',
    '  setTimeout(function() {',
    '    cancelAnimationFrame(animationId);',
    '    particles.forEach(function(p) { p.element.remove(); });',
    '    particles = [];',
    '  }, CONFIG.duration);',
    '}',
    
    'if (CONFIG.trigger === "app_load") {',
    '  if (document.readyState === "loading") {',
    '    document.addEventListener("DOMContentLoaded", startShower);',
    '  } else {',
    '    startShower();',
    '  }',
    '}',
    
    'window.triggerEmojiShower = startShower;'
  )
}
