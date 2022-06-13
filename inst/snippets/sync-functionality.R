# Setup -------------------------------------------------------------------
pkgload::load_all(usethis::proj_get())
source(testthat::test_path("setup-xyz.R"))
s3 <- S3$new()


# remote_to_local ---------------------------------------------------------
s3$
fs::file_create("file_on_")

s3$file_copy()
