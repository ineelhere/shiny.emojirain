test_that("validate_emojis accepts character vector", {
  expect_true(validate_emojis(c("🎉", "🎊")))
})

test_that("validate_emojis rejects non-character input", {
  expect_error(validate_emojis(123), "must be a non-empty character vector")
})

test_that("validate_emojis rejects empty vector", {
  expect_error(validate_emojis(c()), "must be a non-empty character vector")
})

test_that("validate_emojis rejects NULL", {
  expect_error(validate_emojis(NULL), "must be a non-empty character vector")
})

test_that("null coalescing operator works with NULL", {
  result <- NULL %||% "default"
  expect_equal(result, "default")
})

test_that("null coalescing operator works with non-NULL value", {
  result <- "value" %||% "default"
  expect_equal(result, "value")
})

test_that("null coalescing operator works with 0", {
  result <- 0 %||% 99
  expect_equal(result, 0)
})

test_that("null coalescing operator works with FALSE", {
  result <- FALSE %||% TRUE
  expect_false(result)
})

test_that("null coalescing operator works with empty string", {
  result <- "" %||% "default"
  expect_equal(result, "")
})

test_that("null coalescing operator works with empty vector", {
  result <- c() %||% c(1, 2)
  # Empty vector evaluates as falsy, so it returns the right operand
  expect_identical(result, c(1, 2))
})
