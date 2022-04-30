#' @title File System Operations for AWS S3
#'
#' @description Implement a uniform interface to file system operations for AWS S3.
#'
#' @examples
#' s3 <- S3$new(AWS_REGION = "ap-southeast-2")
#'
#' @references
#' This class is based on the idea behind the
#' \href{https://fs.r-lib.org/reference/index.html}{`fs`}.
#'
#' @export
S3 <- R6::R6Class(classname = "Adapter", cloneable = FALSE, public = list(
    # Public Methods ----------------------------------------------------------
    #' @description Instantiate an S3 object
    #' @param AWS_ACCESS_KEY_ID (`character`) Specifies an AWS access key associated with an IAM user or role
    #' @param AWS_SECRET_ACCESS_KEY (`character`) Specifies the secret key associated with the access key. This is essentially the "password" for the access key.
    #' @param AWS_REGION  (`character`) Specifies the AWS Region to send the request to.
    initialize = function(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION, verbose = FALSE) { stop() },
    #' @description Construct path to a file or directory
    #' @param ... (`character`) Character vectors.
    path = function(...) { stop() },
    #' @description Test if a path is an S3 bucket path
    #' @param path (`character`) A path to a file within an S3 bucket.
    is_file = function(path) { stop() },
    #' @description Return the names of the files within the S3 bucket
    #' @param path (`character`) A path to a dir within an S3 bucket.
    is_dir = function(path) { stop() },
    #' @description Return the names of the files within the S3 bucket
    #' @param path (`character`) A path to S3 bucket
    dir_ls = function(path) { stop() },
    #' @description Copy directory form local path to a S3 and vice versa
    #' @param path (`character`) A character vector of one or more paths.
    #' @param new_path (`character`) A character vector of paths to the new locations.
    #' @param overwrite (`logical`) Overwrite files if they exist. If this is `FALSE` and the file exists an error will be thrown.
    dir_copy = function(path, new_path, overwrite = FALSE) { stop() },
    #' @description Copy file form local path to a S3 and vice versa
    #' @param path (`character`) A character vector of one or more paths.
    #' @param new_path (`character`) A character vector of paths to the new locations.
    #' @param overwrite (`logical`) Overwrite files if they exist. If this is `FALSE` and the file exists an error will be thrown.
    file_copy = function(path, new_path, overwrite = FALSE) { stop() },
    #' @description Check if a remote file exists.
    #' @param path (`character`) A character vector of one or more paths.
    file_exists = function(path) { stop() },
    #' @description Return file metadata
    #' @param path (`character`) A character vector of one or more paths.
    file_info = function(path) { stop() },
    #' @description Return file size in bytes
    #' @param path (`character`) A character vector of one or more paths.
    file_size = function(path) { stop() }
), private = list(
    conn = NULL,
    verbose = NULL,
    events = new.env(),
    file_copy_from_remote_to_local = function(path, new_path) { stop() },
    file_copy_from_local_to_remote = function(path, new_path) { stop() }
))


# Public Methods ----------------------------------------------------------
S3$set(which = "public", name = "initialize", overwrite = TRUE, value = function(
    AWS_ACCESS_KEY_ID = Sys.getenv("AWS_ACCESS_KEY_ID"),
    AWS_SECRET_ACCESS_KEY = Sys.getenv("AWS_SECRET_ACCESS_KEY"),
    AWS_REGION = Sys.getenv("AWS_REGION"),
    verbose = FALSE){

    stopifnot(nchar(AWS_ACCESS_KEY_ID) > 0, nchar(AWS_SECRET_ACCESS_KEY) > 0, nchar(AWS_REGION) > 0)
    Sys.setenv(AWS_ACCESS_KEY_ID = AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY = AWS_SECRET_ACCESS_KEY, AWS_REGION = AWS_REGION)

    private$verbose <- verbose
    private$conn <- paws.storage::s3()

    private$events$FAILED_FINDING <- function(path) message("[\033[31mx\033[39m] Failed to find ", path)
    private$events$COPIED_FILE    <- function(path) message("[\033[32mv\033[39m] Copied ", path)
    private$events$SKIPPED_FILE   <- function(path) message("[\033[34mi\033[39m] Skipped ", path)

    invisible()
})


# Directory manipulation --------------------------------------------------
S3$set(which = "public", name = "dir_ls", overwrite = TRUE, value = function(path){
    stopifnot(self$is_dir(path))

    conn <- private$conn
    bucket <- path |> httr::parse_url() |> purrr::pluck("hostname")
    prefix <- path |> httr::parse_url() |> purrr::pluck("path")

    invisible(
        suffix <- conn$list_objects_v2(Bucket = bucket, Prefix = prefix)
        |> purrr::pluck("Contents")
        |> purrr::map(~purrr::keep(.x, names(.x) %in% "Key"))
        |> unlist()
        |> unname()
    )

    return(file.path("s3:/", bucket, suffix))
})


# Path manipulation -------------------------------------------------------
S3$set(which = "public", name = "path", overwrite = TRUE, value = function(...){
    path_components <- list(...)
    stopifnot(self$is_dir(path_components[1]))
    url <- do.call(fs::path, path_components) |> as.character()
    stringr::str_replace(url, ":/", "://")
})

S3$set(which = "public", name = "is_dir", overwrite = TRUE, value = function(path){
    stringr::str_detect(path, "^(s3)://")
})

S3$set(which = "public", name = "is_file", overwrite = TRUE, value = function(path){
    self$is_dir(path)
})


# File manipulation -------------------------------------------------------
S3$set(which = "public", name = "dir_copy", overwrite = TRUE, value = function(path, new_path, overwrite = FALSE){
    if(fs::is_absolute_path(new_path)) fs::dir_create(new_path)

    if(self$is_dir(path) & fs::is_dir(new_path)){
        files <- self$dir_ls(path)[-1]
    } else if (self$is_dir(new_path) & fs::is_dir(path)) {
        files <- fs::dir_ls(path)
    } else {
        stop("dir_copy only supports copying data from local to remote and vice-versa", call. = FALSE)
    }

    for(path in files) {
        self$file_copy(path, new_path, overwrite)
    }

    invisible(new_path)
})

S3$set(which = "public", name = "file_copy", overwrite = TRUE, value = function(path, new_path, overwrite = FALSE){
    if(self$is_file(path) & fs::is_dir(new_path)){
        file_copy <- private$file_copy_from_remote_to_local
        file_exists <- fs::file_exists
        file_path <- fs::path
    } else if (self$is_dir(new_path) & fs::is_file(path)) {
        file_copy <- private$file_copy_from_local_to_remote
        file_exists <- self$file_exists
        file_path <- self$path
    } else {
        stop("file_copy only supports copying data from local to remote and vice-versa", call. = FALSE)
    }

    if(overwrite | !file_exists(file_path(new_path, basename(path)))) {
        file_copy(path, new_path)
        if(private$verbose) private$events$COPIED_FILE(basename(path))
    } else {
        if(private$verbose) private$events$SKIPPED_FILE(basename(path))
    }

    invisible(new_path)
})

S3$set(which = "private", name = "file_copy_from_remote_to_local", overwrite = TRUE, value = function(path, new_path){
    bucket <- path |> httr::parse_url() |> purrr::pluck("hostname")
    key <- path |> httr::parse_url() |> purrr::pluck("path")
    file_path <- fs::path(new_path, basename(path))

    conn <- private$conn
    fs::dir_create(new_path)
    obj <- conn$get_object(Bucket = bucket, Key = key)
    writeBin(obj$Body, file_path)

    invisible(file_path)
})

S3$set(which = "private", name = "file_copy_from_local_to_remote", overwrite = TRUE, value = function(path, new_path){
    bucket <- new_path |> httr::parse_url() |> purrr::pluck("hostname")
    key <- new_path |> httr::parse_url() |> purrr::pluck("path") |> fs::path(basename(path))
    file_path <- self$path(new_path, basename(path))

    conn <- private$conn
    conn$put_object(Bucket = bucket, Key = key, Body = as.character(path))

    invisible(file_path)
})

S3$set(which = "public", name = "file_exists", overwrite = TRUE, value = function(path){
    tryCatch(
        nrow(self$file_info(path)) > 0,
        error = function(e) return(FALSE)
    )
})

S3$set(which = "public", name = "file_size", overwrite = TRUE, value = function(path){
    self$file_info(path)$ContentLength
})

S3$set(which = "public", name = "file_info", overwrite = TRUE, value = function(path){
    self$is_file(path)

    bucket <- path |> httr::parse_url() |> purrr::pluck("hostname")
    key <- path |> httr::parse_url() |> purrr::pluck("path")

    conn <- private$conn
    head_object_safely <- purrr::safely(conn$head_object)

    tryCatch(
        conn$head_object(Bucket = bucket, Key = key) |> purrr::flatten_dfr(),
        error = function(e) stop(paste(path, "not found"), call. = FALSE)
    )
})
