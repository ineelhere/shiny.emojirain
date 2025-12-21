test_that("emoji_shower_ui returns a tag", {
  ui <- emoji_shower_ui()
  expect_true(inherits(ui, "shiny.tag"))
})

test_that("emoji_shower_ui returns a head tag", {
  ui <- emoji_shower_ui()
  expect_equal(ui$name, "head")
})

test_that("emoji_shower_ui accepts default parameters", {
  expect_no_error(emoji_shower_ui())
})

test_that("emoji_shower_ui accepts custom emojis", {
  custom_emojis <- c("❤️", "💕", "💖")
  expect_no_error(emoji_shower_ui(emojis = custom_emojis))
})

test_that("emoji_shower_ui accepts preset emojis", {
  presets <- emoji_presets()
  expect_no_error(emoji_shower_ui(emojis = presets$halloween))
})

test_that("emoji_shower_ui rejects invalid duration", {
  expect_error(emoji_shower_ui(duration = 100),
               "duration must be numeric and >= 500")
})

test_that("emoji_shower_ui rejects non-numeric duration", {
  expect_error(emoji_shower_ui(duration = "fast"),
               "duration must be numeric and >= 500")
})

test_that("emoji_shower_ui rejects invalid fall_speed", {
  expect_error(emoji_shower_ui(fall_speed = -1),
               "fall_speed must be positive numeric")
})

test_that("emoji_shower_ui rejects non-numeric fall_speed", {
  expect_error(emoji_shower_ui(fall_speed = "fast"),
               "fall_speed must be positive numeric")
})

test_that("emoji_shower_ui rejects invalid spin_speed", {
  expect_error(emoji_shower_ui(spin_speed = -5),
               "spin_speed must be positive numeric or NULL")
})

test_that("emoji_shower_ui accepts NULL spin_speed", {
  expect_no_error(emoji_shower_ui(spin_speed = NULL))
})

test_that("emoji_shower_ui accepts valid spin_speed", {
  expect_no_error(emoji_shower_ui(spin_speed = 3))
})

test_that("emoji_shower_ui trigger can be app_load", {
  ui <- emoji_shower_ui(trigger = "app_load")
  expect_no_error(ui)
})

test_that("emoji_shower_ui trigger can be NULL", {
  ui <- emoji_shower_ui(trigger = NULL)
  expect_no_error(ui)
})

test_that("emoji_shower_ui accepts image URLs", {
  image_urls <- c("https://example.com/emoji1.png", 
                  "https://example.com/emoji2.gif")
  expect_no_error(emoji_shower_ui(emojis = image_urls))
})

test_that("emoji_shower_ui accepts http URLs", {
  http_urls <- c("http://example.com/emoji.png")
  expect_no_error(emoji_shower_ui(emojis = http_urls))
})

test_that("emoji_shower_ui accepts data URIs", {
  data_uri <- "data:image/svg+xml,<svg></svg>"
  expect_no_error(emoji_shower_ui(emojis = data_uri))
})

test_that("emoji_shower_ui accepts local file paths", {
  local_paths <- c("/path/to/emoji.png", "./emoji.gif")
  expect_no_error(emoji_shower_ui(emojis = local_paths))
})

test_that("emoji_shower_ui accepts particle_count parameter", {
  expect_no_error(emoji_shower_ui(particle_count = 20))
})

test_that("emoji_shower_ui accepts burst_count parameter", {
  expect_no_error(emoji_shower_ui(burst_count = 12))
})

test_that("emoji_shower_ui accepts image_size parameter", {
  expect_no_error(emoji_shower_ui(image_size = 64))
})

test_that("emoji_shower_ui combines multiple parameters", {
  ui <- emoji_shower_ui(
    emojis = emoji_presets()$birthday,
    trigger = NULL,
    duration = 8000,
    fall_speed = 2.0,
    spin_speed = 2.5,
    particle_count = 20,
    burst_count = 10,
    image_size = 48
  )
  expect_true(inherits(ui, "shiny.tag"))
})

test_that("emoji_shower_ui rejects empty emoji vector", {
  expect_error(emoji_shower_ui(emojis = c()),
               "must be a non-empty character vector")
})

test_that("emoji_shower_ui rejects non-character emojis", {
  expect_error(emoji_shower_ui(emojis = 123),
               "must be a non-empty character vector")
})
