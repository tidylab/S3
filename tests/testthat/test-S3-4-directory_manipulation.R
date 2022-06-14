# Directory manipulation --------------------------------------------------
test_that("dir_ls the names of the files within the S3 bucket", {
    s3 <- S3$new(verbose = FALSE)
    expect_type(s3$dir_ls(remote_dir), "character")
})
