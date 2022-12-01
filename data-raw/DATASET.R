filenames <- list.files("data-raw", pattern = "*.yaml")
spec <- lapply(file.path("data-raw", filenames), yaml::read_yaml)
names(spec) <- substr(filenames, 1, 4)
usethis::use_data(spec, internal = TRUE, overwrite = TRUE)
