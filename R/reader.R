utils::globalVariables("nsduh_download_urls", package = "nsduhus")
#' Print years available for download with the package.
#'
#' @return A character vector of years available.
#' @export
get_nsduhus_available_years <- function() {
  names(nsduh_download_urls)
}

#' Open the codebook from source.
#'
#' @description
#' Open the codebook from \insertCite{nsduh}{nsduhus}
#' for a specific year on a browser.
#'
#' @param year A character string for a year (e.g., 2019).
#' @importFrom Rdpack reprompt
#' @references
#' \insertRef{nsduh}{nsduhus}
#' @export
open_nsduhus_codebook <- function(year) {
  if (year %in% get_nsduhus_available_years()) {
    utils::browseURL(nsduh_download_urls[[year]][["codebook"]])
  } else {
    stop(paste0("Codebook for ", year, " not available yet."))
  }
}

#' Open the questionnaire specs from source.
#'
#' @description
#' Open the questionnaire specs from \insertCite{nsduh}{nsduhus}
#' for a specific year on a browser.
#'
#' @param year A character string for a year (e.g., 2019).
#' @importFrom Rdpack reprompt
#' @references
#' \insertRef{nsduh}{nsduhus}
#' @export
open_nsduhus_qspecs <- function(year) {
  if (year %in% get_nsduhus_available_years()) {
    utils::browseURL(nsduh_download_urls[[year]][["qspecs"]])
  } else {
    stop(paste0("Questionaire specs for ", year, " not available yet."))
  }
}

#' Open the questionnaire showcards from source.
#'
#' @description
#' Open the questionnaire showcards from \insertCite{nsduh}{nsduhus}
#' for a specific year on a browser.
#'
#' @param year A character string for a year (e.g., 2019).
#' @importFrom Rdpack reprompt
#' @references
#' \insertRef{nsduh}{nsduhus}
#' @export
open_nsduhus_qshowcards <- function(year) {
  if (year %in% get_nsduhus_available_years()) {
    if (year == "2005") {
      message(paste0(
        "Questionnaire showcard for ", year,
        " was not available. Opening questionnaire shocard ",
        "for ", year - 1, " instead."
      ))
      year <- year - 1
    }
    utils::browseURL(nsduh_download_urls[[year]][["qshowcards"]])
  } else {
    stop(paste0("Questionaire showcards for ", year, " not available yet."))
  }
}

#' Download zip files.
#'
#' @description
#' Download U.S. NSDUH data files in .zip format
#' from \insertCite{nsduh}{nsduhus}.
#'
#' @param years A character vector of years to download.
#' @param save_to_wd (optional) If TRUE, save to the working directory.
#' @param timeout (optional) Download timeout per file in seconds.
#' @return TRUE if all downloads are successful, FALSE otherwise.
#' @importFrom Rdpack reprompt
#' @references
#' \insertRef{nsduh}{nsduhus}
#' @export
download_nsduhus_zip <- function(years, save_to_wd = FALSE, timeout = 3600) {
  dest <- file.path(
    ifelse(save_to_wd, getwd(), tempdir(check = TRUE)), "nsduhus"
  )
  if (!dir.exists(dest)) dir.create(dest)
  timeout_ <- getOption("timeout")
  options(timeout = timeout)
  years_matched <- check_availability(years, get_nsduhus_available_years())
  success <- length(years_matched) == length(years)
  for (year in years_matched) {
    tryCatch(
      {
        dest_file <- file.path(dest, paste0(year, ".zip"))
        url <- nsduh_download_urls[[year]][["r"]]
        message(paste0("Downloading file ", url, " to ", dest_file))
        resp <- httr::GET(
          url, httr::write_disk(dest_file, overwrite = TRUE),
          httr::progress()
        )
        if (resp$status_code != 200) success <<- FALSE
      },
      warning = function(e) {
        success <<- FALSE
        message(e)
      },
      error = function(e) {
        success <<- FALSE
        message(e)
      }
    )
  }
  options(timeout = timeout_)
  invisible(success)
}

#' Uncompress downloaded zip files.
#'
#' @description
#' Uncompress downloaded  U.S. NSDUH data files in .zip format
#' from \insertCite{nsduh}{nsduhus}.
#'
#' @param years (optional) A character vector of years to uncompress. Uncompress
#'   all downloaded zip files if NULL (default).
#' @param save_to_wd (optional) If TRUE, uncompress to the working directory.
#' @param read_from_wd (optional) If TRUE, downloaded zip files are loaded from
#'   the working directory.
#' @param unzip_method (optional) The method for unzip. See ?unzip.
#' @return TRUE if all files are successfully uncompressed, FALSE otherwise.
#' @importFrom Rdpack reprompt
#' @references
#' \insertRef{nsduh}{nsduhus}
#' @export
uncompress_nsduhus_zip <- function(
    years = NULL, save_to_wd = FALSE,
    read_from_wd = FALSE, unzip_method = "unzip") {
  dest <- file.path(
    ifelse(save_to_wd, getwd(), tempdir(check = TRUE)), "nsduhus"
  )
  if (!dir.exists(dest)) dir.create(dest)
  zipdir <- file.path(
    ifelse(read_from_wd, getwd(), tempdir(check = TRUE)), "nsduhus"
  )
  downloaded <-
    substr(list.files(zipdir, "*\\.zip"), 1, 4)
  if (length(downloaded) == 0) {
    stop(paste("No zip files downloaded in", zipdir))
  }
  if (is.null(years)) years <- downloaded
  years_matched <- check_availability(years, downloaded)
  success <- length(years_matched) == length(years)
  for (year in years_matched) {
    tryCatch(
      {
        zipfile <- file.path(zipdir, paste0(year, ".zip"))
        unzdir <- file.path(dest, year)
        message(paste0(
          "Uncompressing file ", zipfile, " to directory ", unzdir
        ))
        utils::unzip(zipfile, exdir = unzdir, unzip = unzip_method)
      },
      warning = function(e) {
        success <<- FALSE
        message(e)
      },
      error = function(e) {
        success <<- FALSE
        message(e)
      }
    )
  }
  invisible(success)
}

#' Load downloaded U.S. NSDUH data files.
#'
#' @description
#' Load downloaded U.S. NSDUH data files from \insertCite{nsduh}{nsduhus}.
#'
#' @param years (optional) A character vector of years to parse.
#' @param read_from_wd (optional) If TRUE, data files are loaded from
#'   the working directory.
#' @return A list of data frames.
#' @importFrom Rdpack reprompt
#' @references
#' \insertRef{nsduh}{nsduhus}
#' @export
load_nsduhus <- function(years = NULL, read_from_wd = FALSE) {
  srcdir <- file.path(
    ifelse(read_from_wd, getwd(), tempdir(check = TRUE)), "nsduhus"
  )
  srcyears <- list.dirs(srcdir, full.names = FALSE)
  srcyears <- srcyears[nchar(srcyears) > 0]
  if (is.null(years)) years <- srcyears
  years_matched <- check_availability(years, srcyears)
  tmp <- vector(mode = "list", length = length(years_matched))
  names(tmp) <- years_matched
  for (year in years_matched) {
    file <- list.files(file.path(srcdir, year), full.names = TRUE)
    message(paste0("Loading year ", year, " from file ", file, "."))
    tmp[[year]] <- loadrdata(file)
  }
  tmp
}

check_availability <- function(requested, available) {
  is_available <- requested %in% available
  if (any(!is_available)) {
    warning(paste0(
      "Not all years requested are available. Requested years ",
      requested[!is_available], " are ignored."
    ))
    requested <- requested[is_available]
  }
  requested
}

loadrdata <- function(f) {
  load(f)
  get(ls()[ls() != "f"])
}
