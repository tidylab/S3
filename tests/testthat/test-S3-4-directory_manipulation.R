# Setup -------------------------------------------------------------------
s3 <- S3$new(verbose = FALSE)


# Directory manipulation --------------------------------------------------
test_that("dir_exists finds a remote dir", {
    fs::file_create(local_file)
    expect_type(s3$file_copy(local_file, remote_dir, overwrite = TRUE), "character")
    fs::file_delete(local_file)

    existing_remote_dir <- remote_dir
    nonexisting_remote_dir <- s3$path(remote_dir, "xxx")

    expect_true(s3$dir_exists(existing_remote_dir))
    expect_false(s3$dir_exists(nonexisting_remote_dir))
})

test_that("dir_ls the names of the files within the S3 bucket", {
    expect_type(s3$dir_ls(remote_dir), "character")
})

test_that("dir_copy copies a dir from local to S3", {
    expect_type(s3$dir_copy(local_dir, remote_dir, overwrite = TRUE), "character")
})

test_that("dir_copy copies a dir from S3 to local", {
    fs::dir_delete(local_dir)
    expect_type(s3$dir_copy(remote_dir, local_dir, overwrite = TRUE), "character")
})

