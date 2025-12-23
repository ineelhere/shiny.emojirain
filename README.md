# shiny.emojirain 🌧️✨

<!-- badges: start -->
[![R-CMD-check](https://github.com/ineelhere/shiny.emojirain/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ineelhere/shiny.emojirain/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/ineelhere/shiny.emojirain?style=social)](https://github.com/ineelhere/shiny.emojirain/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/ineelhere/shiny.emojirain?style=social)](https://github.com/ineelhere/shiny.emojirain/network/members)
[![GitHub issues](https://img.shields.io/github/issues/ineelhere/shiny.emojirain?color=red)](https://github.com/ineelhere/shiny.emojirain/issues)
[![Website](https://img.shields.io/badge/Documentation-online-informational)](https://ineelhere.github.io/shiny.emojirain)
[![Visitors](https://hits.sh/github.com/ineelhere/shiny.emojirain.svg?label=Visitors&style=flat-square)](https://hits.sh/github.com/ineelhere/shiny.emojirain/)
<!-- badges: end -->

**shiny.emojirain** brings delightful emoji shower animations to your R Shiny applications. Perfect for holidays, celebrations, milestones, and special events! 🎉

Transform your Shiny apps with eye-catching, customizable animations that delight users and add a touch of whimsy to your data dashboards, interactive tools, and web applications.

> **Give this project a ⭐ if you find it useful!** Your support helps us reach more developers and continue improving the package.
___

# [LIVE DEMO](ttps://ineelhere-shiny-emojirain.share.connect.posit.cloud/)
**Experience the package in action** with this **RShiny** application - https://ineelhere-shiny-emojirain.share.connect.posit.cloud/
## 📋 Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Usage Examples](#-usage-examples)
- [Available Presets](#-available-presets)
- [Image Loading Notes](#️-image-loading-considerations)
- [Parameters Reference](#-api-reference)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

*   **🎯 Easy Integration** - Add festive animations with just a few lines of code
*   **🎨 Highly Customizable** - Control speed, rotation, size, opacity, wind, and more
*   **🎭 Flexible Triggers** - Auto-trigger on app load or manually via server-side events
*   **🎪 Pre-built Themes** - 8 ready-to-use presets (Christmas, Halloween, Birthday, etc.)
*   **🖼️ Versatile Content** - Use emojis, custom images, GIFs, or SVGs
*   **⚡ Performance Optimized** - Lightweight, dependency-free, smooth animations
*   **📱 Responsive** - Works seamlessly across all devices and screen sizes

## 📦 Installation

Install the development version from GitHub:

```r
# Install devtools if needed
# install.packages("devtools")

devtools::install_github("ineelhere/shiny.emojirain")
```

## 🚀 Quick Start

Add a festive emoji shower that triggers when your app loads:

```r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  emoji_shower_ui(),  # Uses Christmas theme by default
  h1("Welcome to the Holiday Season! 🎄", align = "center")
)

server <- function(input, output, session) {}

shinyApp(ui, server)
```

## 📖 Usage Examples

### Button-Triggered Shower

Trigger animations based on user interactions:

```r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  setup_emoji_handler(),
  emoji_shower_ui(trigger = NULL),  # Disable auto-trigger
  
  titlePanel("Celebration Station 🎉"),
  actionButton("celebrate", "Click to Celebrate!", 
               class = "btn btn-primary btn-lg")
)

server <- function(input, output, session) {
  observeEvent(input$celebrate, {
    emit_shower(session)
  })
}

shinyApp(ui, server)
```

### Advanced Customization

Customize every aspect of the animation:

```r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  emoji_shower_ui(
    emojis = c("🚀", "⭐", "🪐", "🌙", "✨"),
    trigger = "app_load",
    duration = 8000,        # 8 seconds
    fall_speed = 2,         # Faster falling
    spin_speed = 4,         # Enable rotation
    wind = 0.5,             # Drift to the right
    particle_count = 25,    # More particles
    burst_count = 10,       # More bursts
    opacity = 0.9,          # Slightly transparent
    min_size = 30,          # Larger emojis
    max_size = 50,
    z_index = 9999          # Always on top
  ),
  h1("Space Adventure! 🚀", align = "center")
)

server <- function(input, output, session) {}

shinyApp(ui, server)
```

### Dynamic Server-Side Control

Change the animation properties on the fly:

```r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  setup_emoji_handler(),
  
  titlePanel("Dynamic Emoji Rain"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("theme", "Choose Theme:",
                  choices = c("christmas", "halloween", "birthday", 
                              "love", "party", "success")),
      sliderInput("wind", "Wind Strength:", -2, 2, 0, 0.1),
      sliderInput("speed", "Fall Speed:", 0.5, 3, 1.5, 0.1),
      actionButton("trigger", "Make it Rain!", class = "btn btn-success")
    ),
    mainPanel(
      h3("Click the button to see your custom shower!")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$trigger, {
    emit_shower(
      session,
      emojis = emoji_presets()[[input$theme]],
      wind = input$wind,
      fall_speed = input$speed,
      duration = 5000
    )
  })
}

shinyApp(ui, server)
```

### Using Custom Images

Create branded experiences with your own images:

```r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  emoji_shower_ui(
    emojis = c(
      "https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/2b50.svg",
      "https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f389.svg"
    ),
    image_size = 48,
    trigger = "app_load"
  ),
  h1("Custom Image Shower", align = "center")
)

server <- function(input, output, session) {}

shinyApp(ui, server)
```

### Multiple Themed Buttons

Different themes for different occasions:

```r
library(shiny)
library(shiny.emojirain)

ui <- fluidPage(
  setup_emoji_handler(),
  emoji_shower_ui(trigger = NULL),
  
  titlePanel("Multi-Theme Celebration"),
  
  fluidRow(
    column(4, actionButton("xmas", "🎄 Christmas", class = "btn btn-info btn-block")),
    column(4, actionButton("bday", "🎂 Birthday", class = "btn btn-warning btn-block")),
    column(4, actionButton("halloween", "🎃 Halloween", class = "btn btn-dark btn-block"))
  ),
  br(),
  fluidRow(
    column(4, actionButton("love", "💖 Love", class = "btn btn-danger btn-block")),
    column(4, actionButton("success", "🏆 Success", class = "btn btn-success btn-block")),
    column(4, actionButton("party", "🥳 Party", class = "btn btn-primary btn-block"))
  )
)

server <- function(input, output, session) {
  observeEvent(input$xmas, {
    emit_shower(session, emojis = emoji_presets()$christmas, spin_speed = 2)
  })
  
  observeEvent(input$bday, {
    emit_shower(session, emojis = emoji_presets()$birthday)
  })
  
  observeEvent(input$halloween, {
    emit_shower(session, emojis = emoji_presets()$halloween, opacity = 0.8)
  })
  
  observeEvent(input$love, {
    emit_shower(session, emojis = emoji_presets()$love, fall_speed = 1.2)
  })
  
  observeEvent(input$success, {
    emit_shower(session, emojis = emoji_presets()$success, spin_speed = 3)
  })
  
  observeEvent(input$party, {
    emit_shower(session, emojis = emoji_presets()$party, particle_count = 30)
  })
}

shinyApp(ui, server)
```

## 🎨 Available Presets

The `emoji_presets()` function provides 8 curated emoji collections:

```r
presets <- emoji_presets()
names(presets)
#> [1] "christmas" "halloween" "birthday"  "spring"    "newyear"  
#> [6] "love"      "success"   "party"
```

| Preset | Emojis | Use Case |
|:-------|:-------|:---------|
| `christmas` | 🎄 🎅 ⛄ 🎁 🔔 ✨ ❄️ 🎊 | Holiday season, winter celebrations |
| `halloween` | 🎃 👻 🦇 🕷️ 💀 🧛 🧙 🕯️ | Halloween, spooky themes |
| `birthday` | 🎂 🎈 🎉 🎊 🎁 ⭐ 🌟 🎀 | Birthdays, anniversaries |
| `spring` | 🌸 🦋 🌻 🌺 🌷 🌼 🌹 🐝 | Spring, nature, renewal |
| `newyear` | 🎆 🎇 ✨ 🎉 🥂 ⭐ 🌟 🎊 | New Year celebrations |
| `love` | ❤️ 💕 💖 💗 🌹 💐 💝 💞 | Valentine's Day, romance |
| `success` | 🏆 🥇 🎖️ ⭐ 🌟 💎 👏 🎯 | Achievements, milestones |
| `party` | 🎉 🎊 🎈 🎁 🥳 🍾 🎆 ✨ | General celebrations |

## ⚠️ Image Loading Considerations

**Note on External Image Support**: The ability to render external images (JPEG, PNG, GIF, WebP, SVG) is currently available as an **experimental feature**. While the feature is functional, please be aware of the following:

- **Asynchronous Loading**: External images are loaded asynchronously. Depending on network conditions and file size, images may require additional time to render after the animation begins. For optimal results, ensure images are appropriately sized (32-128px recommended for the `image_size` parameter).
- **Reliability Considerations**: Due to the asynchronous nature of resource loading, image rendering success may vary based on:
  - Network latency and bandwidth
  - CORS (Cross-Origin Resource Sharing) policies of the image host
  - Browser caching behavior
  - Server response times

**Recommendation**: For production environments requiring guaranteed visual consistency, we recommend using Unicode emoji characters instead of external image files. Emojis render immediately without external dependencies and provide superior reliability across all user sessions.

If you intend to use external images, consider implementing fallback emojis in your application for enhanced robustness.

## 📚 Parameter Reference

### `emoji_shower_ui()`

Create the emoji shower animation UI component.

#### Parameters

| Parameter | Type | Default | Description |
|:----------|:-----|:--------|:------------|
| `emojis` | character vector | Christmas set | Emoji characters or image URLs |
| `trigger` | character or NULL | `"app_load"` | When to trigger: `"app_load"` or `NULL` (manual) |
| `duration` | numeric | `6000` | Animation duration in milliseconds |
| `fall_speed` | numeric | `1.5` | Gravity/fall speed (0.5-2.5) |
| `spin_speed` | numeric or NULL | `NULL` | Rotation speed (NULL to disable) |
| `particle_count` | numeric | `15` | Particles per burst (5-30) |
| `burst_count` | numeric | `8` | Number of bursts (1-20) |
| `image_size` | numeric | `32` | Image size in pixels (16-256) |
| `z_index` | numeric | `9999` | CSS z-index for layering |
| `opacity` | numeric | `1` | Particle opacity (0-1) |
| `min_size` | numeric | `20` | Minimum emoji size in pixels |
| `max_size` | numeric | `35` | Maximum emoji size in pixels |
| `wind` | numeric | `0` | Horizontal drift (-2 to 2, positive = right) |

### `setup_emoji_handler()`

Set up the message handler for manual shower triggering. Include this in your UI when using `emit_shower()` in your server.

```r
ui <- fluidPage(
  setup_emoji_handler(),  # Required for manual triggering
  # ... rest of UI
)
```

### `emit_shower(session, ...)`

Trigger an emoji shower from your server code.

#### Parameters

*   `session` - The Shiny session object
*   `...` - Optional named arguments to override configuration (e.g., `emojis`, `wind`, `fall_speed`)

```r
# Basic usage
emit_shower(session)

# With custom parameters
emit_shower(session, 
            emojis = c("🎉", "✨"), 
            wind = 1, 
            duration = 3000)
```

### `emoji_presets()`

Returns a named list of pre-configured emoji collections for common themes.

```r
presets <- emoji_presets()
emoji_shower_ui(emojis = presets$halloween)
```


## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.



---

## 💡 Tips & Tricks

- **Performance**: On resource-constrained devices, reduce `particle_count` and `burst_count` for smoother animations
- **Mobile Friendly**: Test on mobile devices; consider lighter animations for better performance
- **Accessibility**: Use animations sparingly if your audience includes users with motion sensitivity
- **Custom Branding**: Combine with your app's color scheme by using custom emoji/image selections
- **Event Celebrations**: Pair with notifications or milestones to celebrate user achievements

## 🐛 Found a Bug?

Please open an [issue on GitHub](https://github.com/ineelhere/shiny.emojirain/issues) with:
- A clear description of the problem
- Steps to reproduce
- Your R version and OS information
- Expected vs. actual behavior

## 🌟 Show Your Support

If you find **shiny.emojirain** useful, please:
- ⭐ [Star the repository](https://github.com/ineelhere/shiny.emojirain)
- 🐦 Share it on social media
- 💬 Tell us how you're using it in the discussions
- 📢 Recommend it to your colleagues

Your support helps us improve the package and reach more developers! 🚀

---


*Inspired by festive web animations and celebration effects, Built with ❤️ for the R Shiny community*