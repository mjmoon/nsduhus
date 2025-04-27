NSDUHUH_URLS <- yaml::read_yaml("data-raw/urls.yaml")
usethis::use_data(NSDUHUH_URLS, internal = TRUE, overwrite = TRUE)
