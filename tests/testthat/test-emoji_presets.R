test_that("emoji_presets returns a list", {
  presets <- emoji_presets()
  expect_type(presets, "list")
})

test_that("emoji_presets contains all expected themes", {
  presets <- emoji_presets()
  expected_themes <- c(
    "christmas", "halloween", "birthday", "spring",
    "newyear", "love", "success", "party"
  )
  expect_true(all(expected_themes %in% names(presets)))
})

test_that("each preset is a non-empty character vector", {
  presets <- emoji_presets()
  for (theme in names(presets)) {
    expect_type(presets[[theme]], "character")
    expect_gt(length(presets[[theme]]), 0)
  }
})

test_that("christmas preset contains expected emojis", {
  presets <- emoji_presets()
  christmas <- presets$christmas
  expect_true("🎄" %in% christmas)
  expect_true("🎅" %in% christmas)
  expect_true("❄️" %in% christmas)
})

test_that("halloween preset contains expected emojis", {
  presets <- emoji_presets()
  halloween <- presets$halloween
  expect_true("🎃" %in% halloween)
  expect_true("👻" %in% halloween)
})

test_that("birthday preset contains expected emojis", {
  presets <- emoji_presets()
  birthday <- presets$birthday
  expect_true("🎂" %in% birthday)
  expect_true("🎈" %in% birthday)
})

test_that("love preset contains expected emojis", {
  presets <- emoji_presets()
  love <- presets$love
  expect_true("❤️" %in% love)
  expect_true("🌹" %in% love)
})

test_that("success preset contains expected emojis", {
  presets <- emoji_presets()
  success <- presets$success
  expect_true("🏆" %in% success)
  expect_true("🥇" %in% success)
})
