# Constructor -------------------------------------------------------------
test_that("S3 constructor works", {
    expect_s3_class(s3 <- S3$new(verbose = FALSE), "R6")
})
