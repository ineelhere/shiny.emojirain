test_that("setup_emoji_handler returns a tag list", {
  handler <- setup_emoji_handler()
  expect_true(inherits(handler, "shiny.tag.list") || is.list(handler))
})

test_that("setup_emoji_handler creates a script tag", {
  handler <- setup_emoji_handler()
  # Find the script tag in the list
  script_tag <- NULL
  for (item in handler) {
    if (inherits(item, "shiny.tag") && item$name == "script") {
      script_tag <- item
      break
    }
  }
  expect_true(!is.null(script_tag))
  expect_equal(script_tag$name, "script")
})

test_that("setup_emoji_handler script contains triggerEmojiShower", {
  handler <- setup_emoji_handler()
  # Find the script tag
  script_tag <- NULL
  for (item in handler) {
    if (inherits(item, "shiny.tag") && item$name == "script") {
      script_tag <- item
      break
    }
  }
  
  script_content <- as.character(script_tag$children[[1]])
  expect_true(grepl("triggerEmojiShower", script_content))
})

test_that("setup_emoji_handler script contains Shiny reference", {
  handler <- setup_emoji_handler()
  # Find the script tag
  script_tag <- NULL
  for (item in handler) {
    if (inherits(item, "shiny.tag") && item$name == "script") {
      script_tag <- item
      break
    }
  }
  
  script_content <- as.character(script_tag$children[[1]])
  expect_true(grepl("Shiny|addCustomMessageHandler", script_content))
})

test_that("emit_shower rejects non-session input", {
  expect_error(emit_shower("not a session"), 
               "session must be a Shiny session object")
})

test_that("emit_shower rejects NULL session", {
  expect_error(emit_shower(NULL), 
               "session must be a Shiny session object")
})

test_that("emit_shower rejects numeric input", {
  expect_error(emit_shower(123), 
               "session must be a Shiny session object")
})

test_that("emit_shower works with mock ShinySession", {
  mock_session <- structure(list(), class = "ShinySession")
  mock_session$sendCustomMessage <- function(type, msg) {
    # Mock implementation
  }
  expect_invisible(emit_shower(mock_session))
})

test_that("emit_shower returns NULL invisibly", {
  mock_session <- structure(list(), class = "ShinySession")
  mock_session$sendCustomMessage <- function(type, msg) {
    # Mock implementation
  }
  result <- emit_shower(mock_session)
  expect_null(result)
})
