test_that("is_dir detects S3 dir paths", {
    s3 <- S3$new(verbose = FALSE)
    expect_false(s3$is_dir(local_dir))
    expect_true(s3$is_dir(remote_dir))
})

test_that("is_file detects S3 file paths", {
    s3 <- S3$new(verbose = FALSE)
    expect_false(s3$is_file(local_file))
    expect_true(s3$is_file(remote_file))
})
