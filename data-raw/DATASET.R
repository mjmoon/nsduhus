nsduh_download_urls <- yaml::read_yaml("data-raw/urls.yaml")
usethis::use_data(nsduh_download_urls, internal = TRUE, overwrite = TRUE)
