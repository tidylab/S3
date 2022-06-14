# Path manipulation -------------------------------------------------------
test_that("path constructs S3 paths", {
    s3 <- S3$new(verbose = FALSE)
    expect_identical(
        s3$path(remote_dir, "sub-folder-name", "file-name.csv"),
        paste0(remote_dir, "sub-folder-name/file-name.csv")
    )
})
