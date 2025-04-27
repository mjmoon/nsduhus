test_that("Codebook urls are valid.", {
  urls <- sapply(nsduh_download_urls, `[`, "codebook")
  expect_length(urls, length(nsduh_download_urls))
  expect_true(all(sapply(urls, RCurl::url.exists)))
})

test_that("Questionnaire specs urls are valid.", {
  urls <- sapply(nsduh_download_urls, `[`, "qspecs")
  expect_length(urls, length(nsduh_download_urls))
  expect_true(all(sapply(urls, RCurl::url.exists)))
})

test_that("Questionnaire showcards urls are valid.", {
  urls <- sapply(nsduh_download_urls, `[`, "qshowcards")
  expect_length(urls, length(nsduh_download_urls))
  urls$`2005.NA` <- NULL
  expect_true(all(sapply(urls, RCurl::url.exists)))
})

test_that("Data file urls are valid.", {
  urls <- sapply(nsduh_download_urls, `[`, "r")
  expect_length(urls, length(nsduh_download_urls))
  expect_true(all(sapply(urls, RCurl::url.exists)))
})
