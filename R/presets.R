#' Emoji Presets for Common Themes
#'
#' A curated collection of pre-defined emoji sets for popular occasions and themes.
#' These presets provide quick access to thematically appropriate emojis without
#' having to manually select and combine them. Use with [emoji_shower_ui()] via
#' `emojis = emoji_presets()$theme_name` or extract individual presets as needed.
#'
#' @return A named list containing 8 emoji preset vectors. Each preset is a character
#'        vector of emoji strings ready to use with [emoji_shower_ui()].
#'        Available presets:
#'   \itemize{
#'     \item `christmas`: Holiday-themed emojis (Christmas tree, Santa,
#'       snowman, gifts, bells, sparkles, snowflakes, confetti)
#'     \item `halloween`: Spooky-themed emojis (pumpkin, ghost,
#'       bat, spider, skull, vampire, wizard, candle)
#'     \item `birthday`: Party-themed emojis (cake, balloon, party popper,
#'       confetti, gift, star, shining star, ribbon)
#'     \item `spring`: Spring-themed emojis (cherry blossom, butterfly,
#'       sunflower, hibiscus, tulip, daisy, rose, bee)
#'     \item `newyear`: New Year-themed emojis (fireworks, sparkler,
#'       sparkles, party popper, champagne, star, shining star, confetti)
#'     \item `love`: Love/Valentine-themed emojis (red heart, two hearts,
#'       sparkling heart, growing heart, rose, bouquet, gift heart, revolving hearts)
#'     \item `success`: Success/achievement-themed emojis (trophy,
#'       gold medal, medal, star, shining star, gem, clapping hands, target)
#'     \item `party`: General party/celebration-themed emojis (party popper,
#'       confetti, balloon, gift, party face, champagne, fireworks, sparkles)
#'   }
#'
#' @details
#' ## Why Use Presets?
#' Presets save time and ensure thematically consistent animations. Instead of
#' manually curating emoji lists, you can simply use a preset matching your occasion.
#' Each preset has been selected to work well together visually.
#'
#' ## Customization
#' Presets are just starting points! You can:
#' - Combine emojis from multiple presets
#' - Add custom emojis to preset collections
#' - Use presets as reference for creating your own themed sets
#'
#' Example:
#' ```r
#' # Mix presets
#' mixed <- c(emoji_presets()$christmas, emoji_presets()$love)
#' emoji_shower_ui(emojis = mixed)
#'
#' # Extend a preset
#' extended <- c(emoji_presets()$birthday, "cake", "cupcake", "champagne")
#' emoji_shower_ui(emojis = extended)
#' ```
#'
#' @examples
#' \dontrun{
#' # Use a preset
#' emoji_shower_ui(emojis = emoji_presets()$halloween)
#' 
#' # Or extract directly
#' presets <- emoji_presets()
#' presets$birthday
#' }
#'
#' @export
emoji_presets <- function() {
  list(
    christmas = c("\U0001f384", "\U0001f385", "\u26c4", "\U0001f381", "\U0001f514", "\u2728", "\u2744\ufe0f", "\U0001f38a"),
    halloween = c("\U0001f383", "\U0001f47b", "\U0001f987", "\U0001f577\ufe0f", "\U0001f480", "\U0001f9db", "\U0001f9d9", "\U0001f56f\ufe0f"),
    birthday = c("\U0001f382", "\U0001f388", "\U0001f389", "\U0001f38a", "\U0001f381", "\u2b50", "\U0001f31f", "\U0001f380"),
    spring = c("\U0001f338", "\U0001f98b", "\U0001f33b", "\U0001f33a", "\U0001f337", "\U0001f33c", "\U0001f339", "\U0001f41d"),
    newyear = c("\U0001f386", "\U0001f387", "\u2728", "\U0001f389", "\U0001f942", "\u2b50", "\U0001f31f", "\U0001f38a"),
    love = c("\u2764\ufe0f", "\U0001f495", "\U0001f496", "\U0001f497", "\U0001f339", "\U0001f490", "\U0001f49d", "\U0001f49e"),
    success = c("\U0001f3c6", "\U0001f947", "\U0001f396\ufe0f", "\u2b50", "\U0001f31f", "\U0001f48e", "\U0001f44f", "\U0001f3af"),
    party = c("\U0001f389", "\U0001f38a", "\U0001f388", "\U0001f381", "\U0001f973", "\U0001f37e", "\U0001f386", "\u2728")
  )
}
