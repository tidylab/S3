# Create files, directories, or links -------------------------------------
S3$set(which = "private", name = ".file_delete", overwrite = TRUE, value = function(path){
    if(!self$file_exists(path)) events$FAILED_REMOVING_FILE(path)

    bucket <- path |> private$extract_bucket()
    key <- path |> private$extract_key()

    conn <- private$conn
    conn$delete_object(bucket, key)

    return(path)
})


S3$set(which = "private", name = ".dir_delete", overwrite = TRUE, value = function(path){
    if(!self$dir_exists(path)) events$FAILED_REMOVING_DIR(path)

    files <- self$dir_ls(path)
    purrr::walk(files, self$file_delete)

    return(path)
})


# Query for existence and access permissions ------------------------------
S3$set(which = "private", name = ".file_exists", overwrite = TRUE, value = function(path){
    !is.na(self$file_info(path)$size)
})

S3$set(which = "private", name = ".dir_exists", overwrite = TRUE, value = function(path){
    isTRUE(length(self$dir_ls(path)) > 0)
})


# Move or rename files ----------------------------------------------------
S3$set(which = "private", name = ".file_move", overwrite = TRUE, value = function(path, new_path){
    copy_source <- paste0(private$extract_bucket(path), "/", private$extract_key(path))
    bucket <- new_path |> private$extract_bucket()
    key <- new_path |> private$extract_key()

    conn <- private$conn
    conn$copy_object(
        ACL = private$ACL,
        CopySource = copy_source,
        Bucket = bucket,
        Key = key
    )

    self$file_delete(path)
    return(new_path)
})

