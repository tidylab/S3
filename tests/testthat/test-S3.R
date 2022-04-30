# Setup -------------------------------------------------------------------
local_dir   <- usethis::with_project(code = {getwd()})
local_file  <- fs::dir_ls(local_dir)[1]
remote_dir  <- s3_test_dir
remote_file <- paste0(remote_dir, basename(local_file))


# Constructor -------------------------------------------------------------
test_that("S3 constructor works", {
    expect_s3_class(s3 <- S3$new(), "R6")
})


# Path manipulation -------------------------------------------------------
test_that("is_dir detects S3 dir paths", {
    s3 <- S3$new()
    expect_false(s3$is_dir(local_dir))
    expect_true(s3$is_dir(remote_dir))
})

test_that("is_file detects S3 file paths", {
    s3 <- S3$new()
    expect_false(s3$is_file(local_file))
    expect_true(s3$is_file(remote_file))
})

test_that("path constructs S3 paths", {
    s3 <- S3$new()
    expect_identical(
        s3$path(remote_dir, "sub-folder-name", "file-name.csv"),
        paste0(remote_dir, "sub-folder-name/file-name.csv")
    )
})


# Directory manipulation --------------------------------------------------
test_that("dir_ls the names of the files within the S3 bucket", {
    s3 <- S3$new()
    expect_type(s3$dir_ls(remote_dir), "character")
})


# File manipulation -------------------------------------------------------
test_that("file_copy copies a file from local to S3", {
    s3 <- S3$new()
    path <- local_file
    new_path <- remote_dir
    expect_type(s3$file_copy(path, new_path, overwrite = TRUE), "character")
})

test_that("file_copy copies a file from S3 to local", {
    s3 <- S3$new()
    path <- remote_file
    new_path <- fs::path_temp()
    expect_type(s3$file_copy(path, new_path, overwrite = TRUE), "character")
})

test_that("file_copy fails to copy a file from S3 to S3", {
    s3 <- S3$new()
    expect_error(s3$file_copy(remote_file, remote_dir, overwrite = FALSE))
})

test_that("dir_copy copies a dir from local to S3", {
    s3 <- S3$new()
    local_path <- fs::path(fs::path_temp(), "man")
    fs::dir_create(local_path)
    fs::file_create(local_path, "S3", ext = "md")

    expect_type(s3$dir_copy(local_path, remote_dir, overwrite = TRUE), "character")
})

test_that("dir_copy copies a dir from S3 to local", {
    s3 <- S3$new()
    local_path <- fs::path(fs::path_temp(), "man")
    fs::dir_delete(local_path)

    expect_type(s3$dir_copy(remote_dir, local_path, overwrite = TRUE), "character")
})

test_that("file_exists finds a remote file", {
    s3 <- S3$new()
    existing_remote_file <- s3$path(remote_dir, basename(local_file))
    nonexisting_remote_file <- s3$path(remote_dir, "narnia.csv")

    expect_true(s3$file_exists(existing_remote_file))
    expect_false(s3$file_exists(nonexisting_remote_file))
})

test_that("file_size returns file size", {
    s3 <- S3$new()
    expect_type(s3$file_size(remote_file), "double")
})

test_that("file_info returns file metedata", {
    s3 <- S3$new()
    expect_s3_class(s3$file_info(remote_file), "data.frame")
})

test_that("file_info fails when file doesn't exist", {
    s3 <- S3$new()
    nonexisting_remote_file <- fs::path_ext_set(remote_file, "xxx")
    expect_error(s3$file_info(nonexisting_remote_file))
})


