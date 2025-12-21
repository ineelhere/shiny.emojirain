# Emoji Shower UI Component

Creates a festive emoji/image shower animation for R Shiny applications.
Emojis or images fall from the top with optional rotation and
physics-based movement. Perfect for celebrations, holidays, milestones,
and special events!

## Usage

``` r
emoji_shower_ui(
  emojis = c("🎄", "🎅", "⛄", "🎁", "🔔", "✨", "❄️", "🎊", "⭐",
    "🌟"),
  trigger = "app_load",
  duration = 6000,
  fall_speed = 1.5,
  spin_speed = NULL,
  particle_count = 15,
  burst_count = 8,
  image_size = 32
)
```

## Arguments

- emojis:

  Character vector of emoji characters or image URLs to display.
  Defaults to Christmas emojis. Use
  [`emoji_presets()`](https://ineelhere.github.io/shiny.emojirain/reference/emoji_presets.md)
  for pre-made collections or provide your own custom emojis. Supports:
  Unicode emoji characters (e.g., "🎉", "🎄"), web image URLs (http://,
  https://), data URIs, local file paths, and files with extensions
  (.jpg, .png, .gif, .webp, .svg). Emojis will be randomly selected from
  this vector during animation.

- trigger:

  Character string specifying when to trigger the animation. Options:
  "app_load" (automatically triggers on page load) or NULL (manual
  trigger only via
  [`emit_shower()`](https://ineelhere.github.io/shiny.emojirain/reference/emit_shower.md)
  in server). Set to NULL when you want to control when the shower
  appears via user interactions.

- duration:

  Numeric. Total duration of the animation in milliseconds. Controls how
  long the shower effect lasts before clearing particles. Recommended
  range: 2000-10000 (2-10 seconds). Default: 6000 (6 seconds). Shorter
  durations create quick bursts; longer durations sustain the effect.

- fall_speed:

  Numeric. Gravity/velocity factor controlling how fast particles fall.
  Affects the downward acceleration of emojis during the animation.
  Valid range: 0.5-2.5. Default: 1.5. Lower values create slow, elegant
  falls; higher values create rapid, dramatic cascades.

- spin_speed:

  Numeric or NULL. Rotation speed in degrees per animation frame.
  Controls the spin effect applied to particles. Set to a numeric value
  (recommended: 1-5) to enable rotation, or NULL to disable rotation
  (default). Higher values create faster spins. Works great with emojis
  like 💫, ⭐, 🌟.

- particle_count:

  Numeric. Number of emoji/image particles emitted per burst. More
  particles create a denser shower effect but use more resources. Valid
  range: 5-30. Default: 15. Adjust based on your audience's device
  capabilities.

- burst_count:

  Numeric. Number of successive bursts in the animation sequence. A
  burst is a single emission of particles. Multiple bursts create a more
  extended animation effect. Valid range: 1-20. Default: 8. Bursts are
  spaced 200ms apart for a natural staggered effect.

- image_size:

  Numeric. Size of images in pixels (applies only to image URLs, not
  emojis). Controls the width and height of rendered images. Valid
  range: 16-256 pixels. Default: 32. Emoji characters scale
  automatically; this only affects external images.

## Value

A Shiny tag (head tag) with embedded HTML and JavaScript code that
initializes the emoji shower animation. This is meant to be included in
your Shiny UI definition.

## Details

### Rendering and Performance

The shower is rendered as a fixed overlay (z-index: 9999) that covers
the entire viewport without interfering with page interactions
(pointer-events: none). All DOM elements are automatically cleaned up
after animation completes, ensuring no memory leaks or lingering
elements.

### Content Types Supported

The function supports three types of content:

- **Emojis**: Unicode emoji characters ("🎉", "🎄", "❤️", etc.) Font
  size varies between 20-35px for visual variety.

- **Web Images**: URLs starting with "http://", "https://", or "data:"
  URIs. Perfect for custom branding or special images. Uses the
  `image_size` parameter.

- **Local Files**: Relative or absolute paths to image files (.jpg,
  .png, .gif, .webp, .svg). Useful for incorporating assets from your
  Shiny app's www/ folder.

### Physics

Particles start at the top (y = -50) and fall downward with:

- Vertical velocity determined by `fall_speed`

- Horizontal drift from random velocities (-0.3 to 0.3 per frame)

- Optional rotation at the rate specified by `spin_speed`

- Automatic respawn when particles exit the bottom of the viewport

### Integration with Server Control

For advanced customization, combine with
[`setup_emoji_handler()`](https://ineelhere.github.io/shiny.emojirain/reference/setup_emoji_handler.md)
and
[`emit_shower()`](https://ineelhere.github.io/shiny.emojirain/reference/emit_shower.md)
to trigger showers from server-side events.

## Examples

``` r
if (FALSE) { # \dontrun{
library(shiny)

# Simple usage - auto-trigger on load
ui <- fluidPage(
  emoji_shower_ui(),
  h1("Welcome!")
)

# With custom emojis
ui <- fluidPage(
  emoji_shower_ui(
    emojis = emoji_presets()$halloween,
    trigger = NULL,
    spin_speed = 3
  ),
  actionButton("trigger", "Halloween Party!")
)

# With image URLs
ui <- fluidPage(
  emoji_shower_ui(
    emojis = c(
      "https://example.com/star.png",
      "https://example.com/heart.gif"
    ),
    image_size = 48,
    trigger = NULL
  ),
  actionButton("trigger", "Image Shower!")
)
} # }
```
