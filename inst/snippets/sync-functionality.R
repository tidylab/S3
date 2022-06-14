# Setup -------------------------------------------------------------------
pkgload::load_all(usethis::proj_get())
source(testthat::test_path("setup-xyz.R"))
s3 <- S3$new()


# remote_to_local ---------------------------------------------------------
fs::file_create(local_file)
s3$file_copy(local_file, remote_dir)
fs::file_delete(local_file)


local_file_metadata <- fs::file_info(local_file)
remote_file_metadata <- s3$file_info(remote_file)

are_files_synced <- identical(local_file_metadata$size, remote_file_metadata$size)
is_local_exist <- !is.na(local_file_metadata$modification_time)
is_local_ahead <- isTRUE(local_file_metadata$modification_time > remote_file_metadata$modification_time)
is_remote_exist <- !is.na(remote_file_metadata$modification_time)
is_remote_ahead <- isTRUE(local_file_metadata$modification_time < remote_file_metadata$modification_time)

if(is_local_ahead | (is_local_exist & !is_remote_exist)){
    s3$file_copy(local_file, dirname(remote_file), overwrite = TRUE)

} else if (is_remote_ahead | (is_remote_exist & !is_local_exist)) {
    s3$file_copy(remote_file, dirname(local_file), overwrite = TRUE)

} else {
    stop("invalid option")
}
