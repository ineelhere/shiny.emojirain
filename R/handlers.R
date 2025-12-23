#' Setup Emoji Shower Message Handler
#'
#' Enables manual triggering of emoji shower animations from server-side code.
#' This function is required when using [emoji_shower_ui()] with `trigger = NULL`,
#' allowing you to control when showers appear via user interactions or server events.
#'
#' @return A Shiny script tag (`<script>` element) that sets up the custom message
#'        handler for the "triggerEmojiShower" Shiny event. The handler registers
#'        a listener that calls the client-side shower animation function.
#'
#' @details
#' ## How It Works
#' This function injects JavaScript that registers a custom Shiny message handler.
#' When your server code sends the "triggerEmojiShower" message, the handler
#' captures it and executes the shower animation that was set up by [emoji_shower_ui()].
#'
#' ## Usage Pattern
#' Include this in your UI:
#' ```r
#' setup_emoji_handler()
#' emoji_shower_ui(trigger = NULL)  # Important: set trigger = NULL
#' ```
#'
#' Then in your server, trigger the shower with:
#' ```r
#' session$sendCustomMessage("triggerEmojiShower", list())
#' ```
#'
#' Or use the convenience function [emit_shower()] instead:
#' ```r
#' emit_shower(session)
#' ```
#'
#' ## Important Notes
#' - Must be used in the same Shiny app as [emoji_shower_ui()] with `trigger = NULL`
#' - Requires jQuery and Shiny's message handler infrastructure (automatically available)
#' - The shower animation uses the same configuration as set in [emoji_shower_ui()]
#' - Multiple showers can be triggered in sequence or with the same trigger event
#'
#' @examples
#' \dontrun{
#' ui <- fluidPage(
#'   setup_emoji_handler(),
#'   emoji_shower_ui(trigger = NULL),
#'   actionButton("celebrate", "Celebrate!")
#' )
#' 
#' server <- function(input, output, session) {
#'   observeEvent(input$celebrate, {
#'     session$sendCustomMessage("triggerEmojiShower", list())
#'   })
#' }
#' }
#'
#' @export
setup_emoji_handler <- function() {
  shiny::tagList(
    emoji_rain_dependency(),
    shiny::tags$script(shiny::HTML("
      // Wait for Shiny to be ready before registering the handler
      if (typeof Shiny !== 'undefined') {
        Shiny.addCustomMessageHandler('triggerEmojiShower', function(msg) {
          if (typeof window.triggerEmojiShower === 'function') {
            window.triggerEmojiShower(msg);
          }
        });
      }
    "))
  )
}

#' Emit Emoji Shower from Server
#'
#' A convenient wrapper function to trigger an emoji shower animation from your
#' Shiny server code. This is the recommended way to manually trigger showers
#' instead of calling `session$sendCustomMessage()` directly.
#'
#' @param session Shiny session object. This is automatically passed to your
#'        server function as an argument. It provides the connection to communicate
#'        with the client-side JavaScript code.
#' @param ... Optional named arguments to override the default configuration for this specific shower.
#'        Any parameter accepted by [emoji_shower_ui()] (e.g., `emojis`, `fall_speed`, `wind`)
#'        can be passed here.
#'
#' @return NULL (invisibly). The function operates for its side effect of sending
#'        a message to the client to trigger the animation. The return value is
#'        intentionally invisible to avoid printing NULL in interactive contexts.
#'
#' @details
#' ## Requirements
#' This function must be used within a Shiny server function. Additionally,
#' [setup_emoji_handler()] must be included in your app's UI, and [emoji_shower_ui()]
#' must have `trigger = NULL` set.
#'
#' ## Usage
#' Use within any reactive context (observeEvent, reactive, etc.):
#' ```r
#' observeEvent(input$my_button, {
#'   emit_shower(session)
#' })
#' 
#' # With dynamic overrides
#' observeEvent(input$storm, {
#'   emit_shower(session, wind = 2, fall_speed = 4, duration = 2000)
#' })
#' ```
#'
#' Multiple calls to `emit_shower()` will queue animations sequentially.
#' The shower uses the configuration (duration, particles, speed, etc.) set in
#' the original [emoji_shower_ui()] call.
#'
#' ## Error Handling
#' The function validates that `session` is a proper Shiny session object
#' and throws an informative error if an invalid session is provided.
#'
#' @note
#' ## Experimental Feature: External Image Support
#' When passing external image URLs via the `emojis` parameter, note that image 
#' loading is **experimental** and subject to the following considerations:
#' 
#' - **Asynchronous Loading**: External images load asynchronously. Depending on network 
#'   conditions, images may require additional time to render. Use appropriately sized 
#'   images (32-128px recommended).
#' 
#' - **Reliability**: Image rendering success may vary based on network latency, CORS 
#'   policies, browser caching, and server response times.
#' 
#' For production environments, Unicode emoji characters are recommended for guaranteed 
#' visual consistency and superior reliability.
#'
#' @examples
#' \dontrun{
#' server <- function(input, output, session) {
#'   observeEvent(input$celebrate_btn, {
#'     emit_shower(session)
#'   })
#' }
#' }
#'
#' @export
emit_shower <- function(session, ...) {
  if (!inherits(session, "ShinySession")) {
    stop("session must be a Shiny session object", call. = FALSE)
  }
  
  # Capture optional arguments
  args <- list(...)
  
  # Convert parameter names to camelCase for JS (simple mapping)
  # This is a bit manual but safer. 
  # Or I can just pass them and let JS handle/merge, but JS expects camelCase.
  # Let's map common ones.
  js_args <- list()
  if ("fall_speed" %in% names(args)) js_args$fallSpeed <- args$fall_speed
  if ("spin_speed" %in% names(args)) {
      js_args$enableSpin <- TRUE
      js_args$spinSpeed <- args$spin_speed
  }
  if ("particle_count" %in% names(args)) js_args$particleCount <- args$particle_count
  if ("burst_count" %in% names(args)) js_args$burstCount <- args$burst_count
  if ("image_size" %in% names(args)) js_args$imageSize <- args$image_size
  if ("z_index" %in% names(args)) js_args$zIndex <- args$z_index
  if ("min_size" %in% names(args)) js_args$minSize <- args$min_size
  if ("max_size" %in% names(args)) js_args$maxSize <- args$max_size
  
  # Pass through others directly (duration, wind, opacity, emojis)
  direct_pass <- c("duration", "wind", "opacity", "emojis")
  for (p in direct_pass) {
      if (p %in% names(args)) js_args[[p]] <- args[[p]]
  }
  
  session$sendCustomMessage("triggerEmojiShower", js_args)
  invisible(NULL)
}
