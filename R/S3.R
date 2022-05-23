#' @title File System Operations for AWS S3
#'
#' @description Implement a uniform interface to file system operations for AWS S3.
#'
#' @examples
#' \dontrun{
#' s3 <- S3$new(AWS_REGION = "ap-southeast-2")
#' }
#'
#' @references
#' This class is based on the idea behind
#' \href{https://fs.r-lib.org/reference/index.html}{`fs`}.
#'
#' @export
S3 <- R6::R6Class(classname = "Adapter", cloneable = FALSE, public = list(
    # Public Methods ----------------------------------------------------------
    #' @description Instantiate an S3 object
    #' @param AWS_ACCESS_KEY_ID (`character`) Specifies an AWS access key associated with an IAM user or role
    #' @param AWS_SECRET_ACCESS_KEY (`character`) Specifies the secret key associated with the access key. This is essentially the "password" for the access key.
    #' @param AWS_REGION  (`character`) Specifies the AWS Region to send the request to.
    #' @param access_control_list (`character`) What permission should new objects get? By default, all objects are private. Only the owner has full access control. For more information and options see \href{https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#CannedACL}{ACL Overview}.
    initialize = function(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION, access_control_list = "private", verbose = TRUE) { stop() },
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
    ACL = NULL,
    events = new.env(),
    HeadObject = function(...) { stop() },
    file_copy_from_remote_to_local = function(path, new_path) { stop() },
    file_copy_from_local_to_remote = function(path, new_path) { stop() },
    extract_bucket = function(path) { stop() },
    extract_key = function(path) { stop() }
))


# Public Methods ----------------------------------------------------------
S3$set(which = "public", name = "initialize", overwrite = TRUE, value = function(
        AWS_ACCESS_KEY_ID = Sys.getenv("AWS_ACCESS_KEY_ID"),
        AWS_SECRET_ACCESS_KEY = Sys.getenv("AWS_SECRET_ACCESS_KEY"),
        AWS_REGION = Sys.getenv("AWS_REGION"),
        access_control_list = "private",
        verbose = FALSE){

    stopifnot(nchar(AWS_ACCESS_KEY_ID) > 0, nchar(AWS_SECRET_ACCESS_KEY) > 0, nchar(AWS_REGION) > 0)
    withr::with_envvar(
        list(AWS_ACCESS_KEY_ID = AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY = AWS_SECRET_ACCESS_KEY, AWS_REGION = AWS_REGION),
        private$conn <- paws.storage::s3()
    )
    private$verbose <- verbose
    private$ACL <- access_control_list

    private$events$UNSUPPORTED_CASE <- function(name) stop("[\033[31mx\033[39m] ", name, " is unsupported", call. = FALSE)
    private$events$FAILED_FINDING <- function(path) stop("[\033[31mx\033[39m] Failed to find ", path, call. = FALSE)
    private$events$COPIED_FILE    <- function(path) message("[\033[32mv\033[39m] Copied ", path)
    private$events$SKIPPED_FILE   <- function(path) message("[\033[34mi\033[39m] Skipped ", path)

    invisible()
})


# Directory manipulation --------------------------------------------------
S3$set(which = "public", name = "dir_ls", overwrite = TRUE, value = function(path){
    stopifnot(self$is_dir(path))

    conn <- private$conn
    bucket <- path |> private$extract_bucket()
    prefix <- path |> private$extract_key()

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
        dir_ls <- self$dir_ls
        file_exists <- self$file_exists
    } else if (self$is_dir(new_path) & fs::is_dir(path)) {
        file_exists <- fs::file_exists
        dir_ls <- fs::dir_ls
    } else {
        private$events$UNSUPPORTED_CASE("coping a dir from local to local, or from remote to remote")
    }

    for(from in dir_ls(path)) {
        if(!file_exists(from)) next
        self$file_copy(from, new_path, overwrite)
    }

    invisible(new_path)
})

S3$set(which = "public", name = "file_copy", overwrite = TRUE, value = function(path, new_path, overwrite = FALSE){
    ## Assertions
    assert_that(
        assertthat::is.scalar(overwrite), assertthat::is.flag(overwrite),
        assertthat::is.scalar(path), assertthat::is.string(path),
        assertthat::is.scalar(new_path), assertthat::is.string(new_path)
    )


    ## Define Functions
    source_type <- if(self$is_file(path)) "remote" else if(fs::is_file(path)) "local" else stop("Invalid `path`")
    target_type <- if(self$is_dir(new_path)) "remote" else if(fs::is_dir(new_path)) "local" else stop("Invalid `new_path`")
    case <- paste0(source_type,2,target_type)
    switch(case,
           remote2local = {
               if(isFALSE(self$file_exists(path))) private$events$FAILED_FINDING(path)
               file_copy <- private$file_copy_from_remote_to_local
               file_path <- fs::path
               target_file_exists <- fs::file_exists
               source_file_exists <- self$file_exists
           },
           local2remote = {
               if(isFALSE(fs::file_exists(path))) private$events$FAILED_FINDING(path)
               file_copy <- private$file_copy_from_local_to_remote
               file_path <- self$path
               target_file_exists <- self$file_exists
               source_file_exists <- fs::file_exists
           },
           {
               private$events$UNSUPPORTED_CASE("coping a file from local to local, or from remote to remote")
           }
    )

    ## Copy file
    if(overwrite | !target_file_exists(file_path(new_path, basename(path)))) {
        file_copy(path, new_path)
        if(private$verbose) private$events$COPIED_FILE(basename(path))
    } else {
        if(private$verbose) private$events$SKIPPED_FILE(basename(path))
    }

    invisible(new_path)
})

S3$set(which = "private", name = "file_copy_from_remote_to_local", overwrite = TRUE, value = function(path, new_path){
    bucket <- path |> private$extract_bucket()
    key <- path |> private$extract_key()
    file_path <- fs::path(new_path, basename(path))

    conn <- private$conn
    fs::dir_create(new_path)
    obj <- conn$get_object(Bucket = bucket, Key = key)
    writeBin(obj$Body, file_path)

    invisible(file_path)
})

S3$set(which = "private", name = "file_copy_from_local_to_remote", overwrite = TRUE, value = function(path, new_path){
    bucket <- new_path |> private$extract_bucket()
    key <- new_path |> private$extract_key() |> fs::path(basename(path))
    file_path <- self$path(new_path, basename(path))

    conn <- private$conn
    conn$put_object(ACL = private$ACL, Body = as.character(path), Bucket = bucket, Key = key)

    invisible(file_path)
})

S3$set(which = "public", name = "file_exists", overwrite = TRUE, value = function(path){
    nrow(self$file_info(path)) > 0
})

S3$set(which = "public", name = "file_size", overwrite = TRUE, value = function(path){
    self$file_info(path)$size
})

S3$set(which = "public", name = "file_info", overwrite = TRUE, value = function(path){
    stopifnot(self$is_file(path))

    bucket <- path |> private$extract_bucket()
    key <- path |> private$extract_key()

    head_object <- tryCatch({
        head_object <- private$conn$head_object(Bucket = bucket, Key = key) |> purrr::flatten_dfr()
        private$HeadObject(
            path = path,
            type = head_object$ContentType,
            size = head_object$ContentLength,
            modification_time = as.POSIXct(head_object$LastModified, origin = "1970-01-01", tz = "GMT")
        )
        }, error = function(e) return(private$HeadObject())
    )

    return(head_object)
})


# Private Methods ---------------------------------------------------------
S3$set(which = "private", name = "extract_bucket", overwrite = TRUE, value = function(path){
    stopifnot(self$is_file(path) | self$is_dir(path))
    return(path |> httr::parse_url() |> purrr::pluck("hostname"))
})

S3$set(which = "private", name = "extract_key", overwrite = TRUE, value = function(path){
    stopifnot(self$is_file(path) | self$is_dir(path))
    return(path |> httr::parse_url() |> purrr::pluck("path"))
})


# Value Objects -----------------------------------------------------------
S3$set(which = "private", name = "HeadObject", overwrite = TRUE, value = function(
        path              = NA_character_,
        type              = factor(NA_character_),
        size              = fs::fs_bytes(NA_integer_),
        permissions       = fs::fs_perms(NA_integer_),
        modification_time = as.POSIXct(NA),
        user              = NA_character_,
        group             = NA_character_,
        device_id         = NA_real_,
        hard_links        = NA_real_,
        special_device_id = NA_real_,
        inode             = NA_real_,
        block_size        = NA_real_,
        blocks            = NA_real_,
        flags             = NA_integer_,
        generation        = NA_real_,
        access_time       = as.POSIXct(NA),
        change_time       = as.POSIXct(NA),
        birth_time        = as.POSIXct(NA)
){
    as_datetime <- function(x) as.POSIXct(as.integer(x), origin = "1970-01-01", tz = "UTC")

    head_object <- tibble::tibble(
        path              = as.character(path),
        type              = factor(type),
        size              = fs::fs_bytes(size),
        permissions       = fs::fs_perms(permissions),
        modification_time = as_datetime(modification_time),
        user              = as.character(user),
        group             = as.character(group),
        device_id         = as.numeric(device_id),
        hard_links        = as.numeric(hard_links),
        special_device_id = as.numeric(special_device_id),
        inode             = as.numeric(inode),
        block_size        = as.numeric(block_size),
        blocks            = as.numeric(blocks),
        flags             = as.integer(flags),
        generation        = as.numeric(generation),
        access_time       = as_datetime(access_time),
        change_time       = as_datetime(change_time),
        birth_time        = as_datetime(birth_time)
    )

    return(head_object[!is.na(head_object$path),])
})
