#' Validate Emoji/Image Input
#'
#' Internal helper to validate emoji or image content vectors.
#'
#' @param emojis Character vector of emojis or image URLs/paths to validate.
#'
#' @return Logical. TRUE if valid, throws error otherwise.
#'
#' @keywords internal
validate_emojis <- function(emojis) {
  if (!is.character(emojis) || length(emojis) == 0) {
    stop("emojis must be a non-empty character vector of emoji characters or image URLs", call. = FALSE)
  }
  TRUE
}

#' Null Coalescing Operator
#'
#' Returns the left operand if it is not NULL, otherwise returns the right operand.
#'
#' @param x Left operand
#' @param y Right operand (default value)
#'
#' @return x if x is not NULL, otherwise y
#'
#' @keywords internal
#' @name grapes-or-or-grapes
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

#' Emoji Rain Assets Dependency
#'
#' @return An htmlDependency object
#' @keywords internal
emoji_rain_dependency <- function() {
  htmltools::htmlDependency(
    name = "shiny.emojirain",
    version = "1.1.0",
    src = c(file = system.file("assets", package = "shiny.emojirain")),
    script = "emoji_shower.js",
    stylesheet = "emoji_shower.css",
    all_files = TRUE
  )
}
