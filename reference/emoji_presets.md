# Emoji Presets for Common Themes

A curated collection of pre-defined emoji sets for popular occasions and
themes. These presets provide quick access to thematically appropriate
emojis without having to manually select and combine them. Use with
[`emoji_shower_ui()`](https://ineelhere.github.io/shiny.emojirain/reference/emoji_shower_ui.md)
via `emojis = emoji_presets()$theme_name` or extract individual presets
as needed.

## Usage

``` r
emoji_presets()
```

## Value

A named list containing 8 emoji preset vectors. Each preset is a
character vector of emoji strings ready to use with
[`emoji_shower_ui()`](https://ineelhere.github.io/shiny.emojirain/reference/emoji_shower_ui.md).
Available presets:

- `christmas`: Holiday-themed emojis (🎄 Christmas tree, 🎅 Santa, ⛄
  snowman, 🎁 gifts, 🔔 bells, ✨ sparkles, ❄️ snowflakes, 🎊 confetti)

- `halloween`: Spooky-themed emojis (🎃 pumpkin, 👻 ghost, 🦇 bat, 🕷️
  spider, 💀 skull, 🧛 vampire, 🧙 wizard, 🕯️ candle)

- `birthday`: Party-themed emojis (🎂 cake, 🎈 balloon, 🎉 party popper,
  🎊 confetti, 🎁 gift, ⭐ star, 🌟 star, 🎀 ribbon)

- `spring`: Spring-themed emojis (🌸 cherry blossom, 🦋 butterfly, 🌻
  sunflower, 🌺 hibiscus, 🌷 tulip, 🌼 daisy, 🌹 rose, 🐝 bee)

- `newyear`: New Year-themed emojis (🎆 fireworks, 🎇 sparkler, ✨
  sparkles, 🎉 party popper, 🥂 champagne, ⭐ star, 🌟 star, 🎊
  confetti)

- `love`: Love/Valentine-themed emojis (❤️ red heart, 💕 two hearts, 💖
  sparkling heart, 💗 growing heart, 🌹 rose, 💐 bouquet, 💝 gift heart,
  💞 revolving hearts)

- `success`: Success/achievement-themed emojis (🏆 trophy, 🥇 gold
  medal, 🎖️ medal, ⭐ star, 🌟 star, 💎 gem, 👏 clapping hands, 🎯
  target)

- `party`: General party/celebration-themed emojis (🎉 party popper, 🎊
  confetti, 🎈 balloon, 🎁 gift, 🥳 party face, 🍾 champagne, 🎆
  fireworks, ✨ sparkles)

## Details

### Why Use Presets?

Presets save time and ensure thematically consistent animations. Instead
of manually curating emoji lists, you can simply use a preset matching
your occasion. Each preset has been selected to work well together
visually.

### Customization

Presets are just starting points! You can:

- Combine emojis from multiple presets

- Add custom emojis to preset collections

- Use presets as reference for creating your own themed sets

Example:

    # Mix presets
    mixed <- c(emoji_presets()$christmas, emoji_presets()$love)
    emoji_shower_ui(emojis = mixed)

    # Extend a preset
    extended <- c(emoji_presets()$birthday, "🍰", "🧁", "🍾")
    emoji_shower_ui(emojis = extended)

## Examples

``` r
if (FALSE) { # \dontrun{
# Use a preset
emoji_shower_ui(emojis = emoji_presets()$halloween)

# Or extract directly
presets <- emoji_presets()
presets$birthday
} # }
```
