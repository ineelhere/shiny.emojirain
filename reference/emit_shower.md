# Emit Emoji Shower from Server

A convenient wrapper function to trigger an emoji shower animation from
your Shiny server code. This is the recommended way to manually trigger
showers instead of calling `session$sendCustomMessage()` directly.

## Usage

``` r
emit_shower(session, ...)
```

## Arguments

- session:

  Shiny session object. This is automatically passed to your server
  function as an argument. It provides the connection to communicate
  with the client-side JavaScript code.

- ...:

  Optional named arguments to override the default configuration for
  this specific shower. Any parameter accepted by
  [`emoji_shower_ui()`](https://ineelhere.github.io/shiny.emojirain/reference/emoji_shower_ui.md)
  (e.g., `emojis`, `fall_speed`, `wind`) can be passed here.

## Value

NULL (invisibly). The function operates for its side effect of sending a
message to the client to trigger the animation. The return value is
intentionally invisible to avoid printing NULL in interactive contexts.

## Details

### Requirements

This function must be used within a Shiny server function. Additionally,
[`setup_emoji_handler()`](https://ineelhere.github.io/shiny.emojirain/reference/setup_emoji_handler.md)
must be included in your app's UI, and
[`emoji_shower_ui()`](https://ineelhere.github.io/shiny.emojirain/reference/emoji_shower_ui.md)
must have `trigger = NULL` set.

### Usage

Use within any reactive context (observeEvent, reactive, etc.):

    observeEvent(input$my_button, {
      emit_shower(session)
    })

    # With dynamic overrides
    observeEvent(input$storm, {
      emit_shower(session, wind = 2, fall_speed = 4, duration = 2000)
    })

Multiple calls to `emit_shower()` will queue animations sequentially.
The shower uses the configuration (duration, particles, speed, etc.) set
in the original
[`emoji_shower_ui()`](https://ineelhere.github.io/shiny.emojirain/reference/emoji_shower_ui.md)
call.

### Error Handling

The function validates that `session` is a proper Shiny session object
and throws an informative error if an invalid session is provided.

## Note

### Experimental Feature: External Image Support

When passing external image URLs via the `emojis` parameter, note that
image loading is **experimental** and subject to the following
considerations:

- **Asynchronous Loading**: External images load asynchronously.
  Depending on network conditions, images may require additional time to
  render. Use appropriately sized images (32-128px recommended).

- **Reliability**: Image rendering success may vary based on network
  latency, CORS policies, browser caching, and server response times.

For production environments, Unicode emoji characters are recommended
for guaranteed visual consistency and superior reliability.

## Examples

``` r
if (FALSE) { # \dontrun{
server <- function(input, output, session) {
  observeEvent(input$celebrate_btn, {
    emit_shower(session)
  })
}
} # }
```
