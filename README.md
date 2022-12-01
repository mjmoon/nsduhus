
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nsduhus

<!-- badges: start -->

[![R-CMD-check](https://github.com/mjmoon/nsduhus/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mjmoon/nsduhus/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/mjmoon/nsduhus/branch/main/graph/badge.svg?token=SAK9r1dBLH)](https://codecov.io/gh/mjmoon/nsduhus)
<!-- badges: end -->

The goal of `nsduhus` is to provide easy and reproducible access to [the
U.S. National Survey on Drug Use and Health data
files](https://www.samhsa.gov/data/data-we-collect/nsduh-national-survey-drug-use-and-health)
from Substance Abuse and Mental Health Administration, US Department of
Health and Human Services. Currently, data files from 2002 to 2020 are
available for download using the package.

## Installation

You can install the development version of nsduhus from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mjmoon/nsduhus")
```

## Example

The functions allow you to download zip files, uncompress the RData data
files, and load the R data frame objects.

``` r
library(nsduhus)
download_nsduhus_zip("2019")
uncompress_nsduhus_zip("2019")
mcd2019 <- load_nsduhus("2019")[["2019"]]
```

To check the data codebook, you can open up the source documentation
online from the package.

``` r
open_nsduhus_codebook("2019")
```
