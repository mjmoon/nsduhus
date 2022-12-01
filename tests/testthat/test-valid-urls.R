test_that("Codebook urls are valid.", {
  urls <- sapply(spec, `[`, "url-codebook")
  expect_length(urls, length(spec))
  expect_true(all(sapply(urls, RCurl::url.exists)))
})

test_that("Questionnaire specs urls are valid.", {
  urls <- sapply(spec, `[`, "url-qspecs")
  expect_length(urls, length(spec))
  expect_true(all(sapply(urls, RCurl::url.exists)))
})

test_that("Questionnaire showcards urls are valid.", {
  urls <- sapply(spec, `[`, "url-qshowcards")
  expect_length(urls, length(spec))
  expect_true(all(sapply(urls, RCurl::url.exists)))
})

test_that("Data file urls are valid.", {
  urls <- sapply(spec, `[`, "url-r")
  expect_length(urls, length(spec))
  expect_true(all(sapply(urls, RCurl::url.exists)))
})
