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
  shiny::tags$script(shiny::HTML("
    $(document).ready(function() {
      Shiny.addCustomMessageHandler('triggerEmojiShower', function(msg) {
        if (typeof window.triggerEmojiShower === 'function') {
          window.triggerEmojiShower();
        }
      });
    });
  "))
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
emit_shower <- function(session) {
  if (!inherits(session, "ShinySession")) {
    stop("session must be a Shiny session object", call. = FALSE)
  }
  session$sendCustomMessage("triggerEmojiShower", list())
  invisible(NULL)
}
