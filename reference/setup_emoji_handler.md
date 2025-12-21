# Setup Emoji Shower Message Handler

Enables manual triggering of emoji shower animations from server-side
code. This function is required when using
[`emoji_shower_ui()`](https://ineelhere.github.io/shiny.emojirain/reference/emoji_shower_ui.md)
with `trigger = NULL`, allowing you to control when showers appear via
user interactions or server events.

## Usage

``` r
setup_emoji_handler()
```

## Value

A Shiny script tag (`<script>` element) that sets up the custom message
handler for the "triggerEmojiShower" Shiny event. The handler registers
a listener that calls the client-side shower animation function.

## Details

### How It Works

This function injects JavaScript that registers a custom Shiny message
handler. When your server code sends the "triggerEmojiShower" message,
the handler captures it and executes the shower animation that was set
up by
[`emoji_shower_ui()`](https://ineelhere.github.io/shiny.emojirain/reference/emoji_shower_ui.md).

### Usage Pattern

Include this in your UI:

    setup_emoji_handler()
    emoji_shower_ui(trigger = NULL)  # Important: set trigger = NULL

Then in your server, trigger the shower with:

    session$sendCustomMessage("triggerEmojiShower", list())

Or use the convenience function
[`emit_shower()`](https://ineelhere.github.io/shiny.emojirain/reference/emit_shower.md)
instead:

    emit_shower(session)

### Important Notes

- Must be used in the same Shiny app as
  [`emoji_shower_ui()`](https://ineelhere.github.io/shiny.emojirain/reference/emoji_shower_ui.md)
  with `trigger = NULL`

- Requires jQuery and Shiny's message handler infrastructure
  (automatically available)

- The shower animation uses the same configuration as set in
  [`emoji_shower_ui()`](https://ineelhere.github.io/shiny.emojirain/reference/emoji_shower_ui.md)

- Multiple showers can be triggered in sequence or with the same trigger
  event

## Examples

``` r
if (FALSE) { # \dontrun{
ui <- fluidPage(
  setup_emoji_handler(),
  emoji_shower_ui(trigger = NULL),
  actionButton("celebrate", "Celebrate!")
)

server <- function(input, output, session) {
  observeEvent(input$celebrate, {
    session$sendCustomMessage("triggerEmojiShower", list())
  })
}
} # }
```
