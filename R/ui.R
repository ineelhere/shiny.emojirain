#' Emoji Shower UI Component
#'
#' Creates a festive emoji/image shower animation for R Shiny applications.
#' Emojis or images fall from the top with optional rotation and physics-based movement.
#' Perfect for celebrations, holidays, milestones, and special events!
#'
#' @param emojis Character vector of emoji characters or image URLs to display.
#'        Defaults to Christmas emojis (if NULL). Use [emoji_presets()] for pre-made collections
#'        or provide your own custom emojis. Supports: Unicode emoji characters
#'        (e.g., actual emoji symbols), web image URLs (http://, https://), data URIs,
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
#'        Higher values create faster spins. Works great with spinning or star emojis.
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
#' @param z_index Numeric. CSS z-index for the animation layer. Default: 9999.
#'        Ensure this is high enough to appear on top of other elements.
#' @param opacity Numeric. Opacity of the particles (0.0 to 1.0). Default: 1.
#' @param min_size Numeric. Minimum font size for emoji particles in pixels. Default: 20.
#' @param max_size Numeric. Maximum font size for emoji particles in pixels. Default: 35.
#' @param wind Numeric. Horizontal drift bias. Positive values blow right, negative left. Default: 0.
#'
#' @return A Shiny tag list containing the necessary HTML dependencies and initialization script.
#'
#' @details
#' ## Rendering and Performance
#' The shower is rendered as a fixed overlay that covers the entire
#' viewport without interfering with page interactions (pointer-events: none).
#' All DOM elements are automatically cleaned up after animation completes,
#' ensuring no memory leaks or lingering elements.
#'
#' ## Content Types Supported
#' The function supports three types of content:
#' - **Emojis**: Unicode emoji characters ("🎉", "🎄", "❤️", etc.)
#'   Font size varies between `min_size` and `max_size` for visual variety.
#' - **Web Images**: URLs starting with "http://", "https://", or "data:" URIs.
#'   Perfect for custom branding or special images. Uses the `image_size` parameter.
#' - **Local Files**: Relative or absolute paths to image files (.jpg, .png, .gif,
#'   .webp, .svg). Useful for incorporating assets from your Shiny app's www/ folder.
#'
#' ## Physics
#' Particles start at the top (y = -50) and fall downward with:
#' - Vertical velocity determined by `fall_speed`
#' - Horizontal drift from random velocities plus `wind` bias
#' - Optional rotation at the rate specified by `spin_speed`
#' - Automatic respawn when particles exit the bottom of the viewport
#'
#' ## Integration with Server Control
#' For advanced customization, combine with [setup_emoji_handler()] and
#' [emit_shower()] to trigger showers from server-side events.
#'
#' @note
#' ## Experimental Feature: External Image Support
#' The ability to render external images (JPEG, PNG, GIF, WebP, SVG) is currently 
#' available as an **experimental feature**. While functional, be aware that:
#' 
#' - **Asynchronous Loading**: External images load asynchronously. Depending on network 
#'   conditions and file size, images may require additional time to render after the 
#'   animation begins. For optimal results, use appropriately sized images (32-128px 
#'   recommended for the `image_size` parameter).
#' 
#' - **Reliability Considerations**: Image rendering success may vary based on network 
#'   latency, CORS policies of the image host, browser caching behavior, and server 
#'   response times.
#' 
#' **Recommendation**: For production environments requiring guaranteed visual consistency, 
#' use Unicode emoji characters instead of external image files. Emojis render immediately 
#' without external dependencies and provide superior reliability across all user sessions. 
#' If using external images, consider implementing fallback emojis for enhanced robustness.
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
#' # With custom emojis and wind
#' ui <- fluidPage(
#'   emoji_shower_ui(
#'     emojis = emoji_presets()$halloween,
#'     trigger = NULL,
#'     spin_speed = 3,
#'     wind = 0.2
#'   ),
#'   actionButton("trigger", "Halloween Party!")
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
  image_size = 32,
  z_index = 9999,
  opacity = 1,
  min_size = 20,
  max_size = 35,
  wind = 0
) {
  
  # Validate inputs
  if (!is.numeric(duration) || duration < 500) stop("duration must be numeric and >= 500 ms", call. = FALSE)
  if (!is.numeric(fall_speed) || fall_speed <= 0) stop("fall_speed must be positive numeric", call. = FALSE)
  if (!is.null(spin_speed) && (!is.numeric(spin_speed) || spin_speed <= 0)) stop("spin_speed must be positive numeric or NULL", call. = FALSE)
  if (!is.numeric(particle_count) || particle_count < 1) stop("particle_count must be positive numeric", call. = FALSE)
  if (!is.numeric(burst_count) || burst_count < 1) stop("burst_count must be positive numeric", call. = FALSE)
  if (!is.numeric(image_size) || image_size < 16 || image_size > 256) stop("image_size must be numeric between 16 and 256", call. = FALSE)
  if (!is.numeric(z_index)) stop("z_index must be numeric", call. = FALSE)
  if (!is.numeric(opacity) || opacity < 0 || opacity > 1) stop("opacity must be between 0 and 1", call. = FALSE)
  if (!is.numeric(min_size) || min_size <= 0) stop("min_size must be positive", call. = FALSE)
  if (!is.numeric(max_size) || max_size <= min_size) stop("max_size must be greater than min_size", call. = FALSE)
  if (!is.numeric(wind)) stop("wind must be numeric", call. = FALSE)
  
  # Validate emojis
  validate_emojis(emojis)
  
  # Convert emojis/images to JSON
  emojis_json <- jsonlite::toJSON(emojis, auto_unbox = FALSE)
  
  # Build config object
  config_list <- list(
    emojis = emojis,
    duration = duration,
    fallSpeed = fall_speed,
    enableSpin = !is.null(spin_speed),
    spinSpeed = if (is.null(spin_speed)) 3 else spin_speed,
    particleCount = particle_count,
    burstCount = burst_count,
    imageSize = image_size,
    trigger = trigger %||% "manual",
    zIndex = z_index,
    opacity = opacity,
    minSize = min_size,
    maxSize = max_size,
    wind = wind
  )
  
  config_json <- jsonlite::toJSON(config_list, auto_unbox = TRUE)
  
  shiny::tagList(
    shiny::tags$head(
      emoji_rain_dependency(),
      shiny::tags$script(shiny::HTML(paste0("window.EmojiRainConfig = ", config_json, ";")))
    ),
    shiny::tags$div(
      id = "emoji-shower-container",
      style = "position: fixed; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; z-index: 9999; overflow: hidden;"
    )
  )
}
