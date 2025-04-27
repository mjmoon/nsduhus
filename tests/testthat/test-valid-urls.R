test_that("Codebook urls are valid.", {
  urls <- sapply(NSDUHUH_URLS, `[`, "codebook")
  expect_length(urls, length(NSDUHUH_URLS))
  expect_true(all(sapply(urls, RCurl::url.exists)))
})

test_that("Questionnaire specs urls are valid.", {
  urls <- sapply(NSDUHUH_URLS, `[`, "qspecs")
  expect_length(urls, length(NSDUHUH_URLS))
  expect_true(all(sapply(urls, RCurl::url.exists)))
})

test_that("Questionnaire showcards urls are valid.", {
  urls <- sapply(NSDUHUH_URLS, `[`, "qshowcards")
  expect_length(urls, length(NSDUHUH_URLS))
  urls$`2005.NA` <- NULL
  expect_true(all(sapply(urls, RCurl::url.exists)))
})

test_that("Data file urls are valid.", {
  urls <- sapply(NSDUHUH_URLS, `[`, "r")
  expect_length(urls, length(NSDUHUH_URLS))
  expect_true(all(sapply(urls, RCurl::url.exists)))
})
