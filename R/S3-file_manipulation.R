S3$set(which = "private", name = ".file_delete", overwrite = TRUE, value = function(path){
    if(!self$file_exists(path)) events$FAILED_REMOVING(path)

    bucket <- path |> private$extract_bucket()
    key <- path |> private$extract_key()

    conn <- private$conn
    conn$delete_object(bucket, key)

    return(path)
})
