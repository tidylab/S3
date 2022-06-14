# S3 ----------------------------------------------------------------------
local_dir   <- fs::file_temp("S3-")
local_file  <- fs::path(local_dir, "dummy", ext = "R")
remote_dir  <- "s3://tidylab/S3/testthat/"
remote_file <- paste0(remote_dir, basename(local_file))

fs::dir_create(local_dir)
fs::file_create(local_file)
