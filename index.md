# shiny.emojirain

[![R-CMD-check](https://github.com/ineelhere/shiny.emojirain/workflows/R-CMD-check/badge.svg)](https://github.com/ineelhere/shiny.emojirain/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/shiny.emojirain)](https://CRAN.R-project.org/package=shiny.emojirain)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![GitHub last
commit](https://img.shields.io/github/last-commit/ineelhere/shiny.emojirain)![GitHub
stars](https://img.shields.io/github/stars/ineelhere/shiny.emojirain?style=social)

Create stunning emoji shower animations for your R Shiny applications!
🎉 Add festive, celebratory effects with customizable speed, rotation,
and emojis—perfect for holidays, celebrations, and special events.

## Features

✨ **Zero Dependencies** - Lightweight JavaScript, no external libraries
needed  
🎨 **Highly Customizable** - Control speed, rotation, particle count,
and more  
🎭 **Multiple Emoji Presets** - Christmas, Halloween, Birthday, Spring,
New Year, Love, Success, Party  
🖼️ **Image Support** - Use emoji characters, web images, or local
files  
⚡ **Performance Optimized** - Smooth animations with efficient DOM
handling  
🎯 **Easy Integration** - Simple API, works seamlessly with Shiny  
📱 **Responsive** - Works on all screen sizes and devices

## Installation

Install from GitHub:

``` r
# Install devtools if you haven't already
install.packages("devtools")

# Install shiny.emojirain
devtools::install_github("ineelhere/shiny.emojirain")
```

## Quick Start

### Basic Usage - Auto-trigger on Page Load

``` r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  emoji_shower_ui(),
  h1("Welcome to the Celebration!")
)

server <- function(input, output, session) {}

shinyApp(ui, server)
```

### With Custom Emojis

``` r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  emoji_shower_ui(
    emojis = c("🎄", "🎅", "⛄", "🎁", "❄️"),
    trigger = "app_load",
    duration = 8000,
    fall_speed = 1.2,
    particle_count = 20
  ),
  h1("Christmas Celebration!")
)

server <- function(input, output, session) {}

shinyApp(ui, server)
```

### Using Emoji Presets

``` r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  emoji_shower_ui(
    emojis = emoji_presets()$halloween,
    duration = 6000,
    spin_speed = 2
  ),
  h1("🎃 Happy Halloween! 👻")
)

server <- function(input, output, session) {}

shinyApp(ui, server)
```

### Manual Trigger with Server-side Control

``` r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  setup_emoji_handler(),
  emoji_shower_ui(trigger = NULL),
  h2("Birthday Bash!"),
  actionButton("celebrate", "🎉 Click to Celebrate!", 
               class = "btn btn-success btn-lg")
)

server <- function(input, output, session) {
  observeEvent(input$celebrate, {
    emit_shower(session)
  })
}

shinyApp(ui, server)
```

### Advanced: Custom Parameters

``` r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  setup_emoji_handler(),  # Required for manual triggering
  emoji_shower_ui(
    emojis = emoji_presets()$party,
    trigger = NULL,
    duration = 10000,      # 10 second animation
    fall_speed = 2.0,      # Faster falling
    spin_speed = 3,        # Noticeable rotation
    particle_count = 25,   # More particles
    burst_count = 12,      # More bursts
    image_size = 48        # Larger emoji size
  ),
  h1("🥳 New Year Party! 🎆"),
  actionButton("party", "Start the Party!", class = "btn btn-primary btn-lg"),
  br(), br(),
  p("Click the button to trigger the emoji shower!")
)

server <- function(input, output, session) {
  observeEvent(input$party, {
    emit_shower(session)
  })
}

shinyApp(ui, server)
```

### With Web Images

``` r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  emoji_shower_ui(
    emojis = c(
      "https://via.placeholder.com/32/FFD700/FFD700?text=★",
      "https://via.placeholder.com/32/FF69B4/FF69B4?text=♥"
    ),
    image_size = 32,
    trigger = "app_load"
  ),
  h1("Custom Image Shower!")
)

server <- function(input, output, session) {}

shinyApp(ui, server)
```

### Multiple Showers with Different Triggers

``` r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  setup_emoji_handler(),
  h1("Multi-Shower Demo"),
  
  # First shower - auto-trigger
  emoji_shower_ui(
    emojis = emoji_presets()$christmas,
    duration = 6000
  ),
  
  # Control buttons for manual showers
  br(),
  actionButton("xmas", "❄️ Christmas", class = "btn btn-info"),
  actionButton("bday", "🎂 Birthday", class = "btn btn-warning"),
  actionButton("halloween", "👻 Halloween", class = "btn btn-dark")
)

server <- function(input, output, session) {
  observeEvent(input$xmas, {
    emit_shower(session)
  })
  
  observeEvent(input$bday, {
    emit_shower(session)
  })
  
  observeEvent(input$halloween, {
    emit_shower(session)
  })
}

shinyApp(ui, server)
```

### Love/Valentine Theme

Create a romantic experience with a shower of hearts and roses:

``` r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  emoji_shower_ui(
    emojis = emoji_presets()$love,
    duration = 7000,
    fall_speed = 1.3,
    spin_speed = 2.5,
    trigger = "app_load"
  ),
  h1("💕 Spread the Love! 💕"),
  p("Perfect for Valentine's Day, anniversaries, or expressing appreciation!")
)

server <- function(input, output, session) {}

shinyApp(ui, server)
```

## Available Emoji Presets

Use the
[`emoji_presets()`](https://ineelhere.github.io/shiny.emojirain/reference/emoji_presets.md)
function to access pre-made emoji collections:

``` r
# View all available presets
presets <- emoji_presets()
names(presets)

# Use a specific preset
emoji_presets()$christmas   # 🎄 🎅 ⛄ 🎁 🔔 ✨ ❄️ 🎊
emoji_presets()$halloween   # 🎃 👻 🦇 🕷️ 💀 🧛 🧙 🕯️
emoji_presets()$birthday    # 🎂 🎈 🎉 🎊 🎁 ⭐ 🌟 🎀
emoji_presets()$spring      # 🌸 🦋 🌻 🌺 🌷 🌼 🌹 🐝
emoji_presets()$newyear     # 🎆 🎇 ✨ 🎉 🥂 ⭐ 🌟 🎊
emoji_presets()$love        # ❤️ 💕 💖 💗 🌹 💐 💝 💞
emoji_presets()$success     # 🏆 🥇 🎖️ ⭐ 🌟 💎 👏 🎯
emoji_presets()$party       # 🎉 🎊 🎈 🎁 🥳 🍾 🎆 ✨
```

## Function Reference

### `emoji_shower_ui()`

Create the emoji shower animation UI component.

**Parameters:** - `emojis` - Character vector of emoji characters or
image URLs (default: Christmas emojis) - `trigger` - When to trigger
(`"app_load"` or `NULL` for manual) - `duration` - Animation duration in
milliseconds (default: 6000) - `fall_speed` - Gravity factor, 0.5-2.5
(default: 1.5) - `spin_speed` - Rotation speed in degrees/frame
(default: NULL) - `particle_count` - Number of particles per burst, 5-30
(default: 15) - `burst_count` - Number of bursts, 1-20 (default: 8) -
`image_size` - Image size in pixels, 16-256 (default: 32)

### `emoji_presets()`

Get a named list of pre-made emoji collections for common themes.

### `setup_emoji_handler()`

Set up the Shiny message handler for manual shower triggering.

### `emit_shower(session)`

Trigger an emoji shower from your server code. Requires
[`setup_emoji_handler()`](https://ineelhere.github.io/shiny.emojirain/reference/setup_emoji_handler.md)
in UI.

## Testing

Run the test suite:

``` r
devtools::test()
```

## Contributing

Found a bug? Have a feature request? Please open an issue on
[GitHub](https://github.com/ineelhere/shiny.emojirain/issues).

## License

MIT License - see
[LICENSE](https://ineelhere.github.io/shiny.emojirain/LICENSE) file for
details.

## Author

**Indraneel Chakraborty**  
[GitHub](https://github.com/ineelhere) \|
[Email](mailto:hello.indraneel@gmail.com)
