year <- "2020"
year_unavailable <- "1800"

test_that("Available specification document opens.", {
  expect_no_error(open_nsduhus_codebook(year))
  expect_no_error(open_nsduhus_qspecs(year))
  expect_no_error(open_nsduhus_qshowcards(year))
})

test_that("Requesting for an unavilable year throws an error.", {
  expect_error(open_nsduhus_codebook(year_unavailable))
  expect_error(open_nsduhus_qspecs(year_unavailable))
  expect_error(open_nsduhus_qshowcards(year_unavailable))
})
