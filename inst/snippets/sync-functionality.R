# Setup -------------------------------------------------------------------
pkgload::load_all(usethis::proj_get())
source(testthat::test_path("setup-xyz.R"))
s3 <- S3$new()


# remote_to_local ---------------------------------------------------------
fs::file_create(local_file)
s3$file_copy(local_file, remote_dir)
fs::file_delete(local_file)


are_files_synced <- isTRUE(as.integer(s3$file_size(remote_file)) == as.integer(fs::file_size(local_file)))

#' cases:
#' 1) Files are synced --> do nothing
#' 2) Local file is ahead --> copy local file to remote
#' 3) Remote file is ahead --> copy remote file to local

local_file_metadata <- fs::file_info(local_file)
remote_file_metadata <- s3$file_info(remote_file1)

# if(isFALSE(are_files_synced)) s3$file_copy(remote_file1, local_path, overwrite = TRUE)
