# File manipulation -------------------------------------------------------
test_that("file_copy copies a file from local to S3", {
    s3 <- S3$new(verbose = FALSE)
    fs::file_create(local_file)
    expect_type(s3$file_copy(local_file, remote_dir, overwrite = TRUE), "character")
})

test_that("file_copy copies a file from S3 to local", {
    s3 <- S3$new(verbose = FALSE)
    fs::file_delete(local_file)
    expect_type(s3$file_copy(remote_file, local_dir, overwrite = TRUE), "character")
})

test_that("file_copy fails to copy a file from S3 to S3", {
    s3 <- S3$new(verbose = FALSE)
    non_existing_local_file <- fs::path(local_dir, "file452047e24959.csv")
    non_existing_remote_file <- s3$path(remote_dir, "file452047e24959.csv")
    expect_error(s3$file_copy(remote_file, remote_dir, overwrite = FALSE))
    expect_error(s3$file_copy(non_existing_local_file, remote_dir, overwrite = FALSE))
    expect_error(s3$file_copy(non_existing_remote_file, local_dir, overwrite = FALSE))
})

test_that("dir_copy copies a dir from local to S3", {
    s3 <- S3$new(verbose = FALSE)
    expect_type(s3$dir_copy(local_dir, remote_dir, overwrite = TRUE), "character")
})

test_that("dir_copy copies a dir from S3 to local", {
    s3 <- S3$new(verbose = FALSE)
    fs::dir_delete(local_dir)
    expect_type(s3$dir_copy(remote_dir, local_dir, overwrite = TRUE), "character")
})

test_that("file_exists finds a remote file", {
    s3 <- S3$new(verbose = FALSE)
    fs::file_create(local_file)
    expect_type(s3$file_copy(local_file, remote_dir, overwrite = TRUE), "character")
    fs::file_delete(local_file)

    existing_remote_file <- s3$path(remote_dir, basename(local_file))
    nonexisting_remote_file <- s3$path(remote_dir, "narnia.csv")

    expect_true(s3$file_exists(existing_remote_file))
    expect_false(s3$file_exists(nonexisting_remote_file))
})

test_that("file_info returns file metedata", {
    s3 <- S3$new(verbose = FALSE)
    fs::file_create(local_file)
    expect_type(s3$file_copy(local_file, remote_dir, overwrite = TRUE), "character")
    fs::file_delete(local_file)

    existing_remote_file <- s3$path(remote_dir, basename(local_file))
    nonexisting_remote_file <- s3$path(remote_dir, "narnia.csv")

    expect_s3_class(s3$file_info(existing_remote_file), "data.frame")
    expect_s3_class(s3$file_info(nonexisting_remote_file), "data.frame")
})

test_that("file_size returns file size", {
    s3 <- S3$new(verbose = FALSE)
    expect_s3_class(s3$file_size(remote_file), "fs_bytes")
})

test_that("file_delete deletes a file from S3", {
    s3 <- S3$new(verbose = FALSE)
    fs::file_create(local_file)
    remote_file <- s3$path(remote_dir, basename(local_file))

    expect_type(s3$file_copy(local_file, remote_dir, overwrite = TRUE), "character")
    expect_s3_class(s3$file_delete(remote_file), "FileSystemModule")
    expect_error(s3$file_delete(remote_file), "Failed to remove")
})
