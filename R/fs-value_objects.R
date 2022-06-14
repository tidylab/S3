#' @title FileInfo Value Object
#'
#' @param path ?
#' @param type ?
#' @param size ?
#' @param permissions ?
#' @param modification_time ?
#' @param user ?
#' @param group ?
#' @param device_id ?
#' @param hard_links ?
#' @param special_device_id ?
#' @param inode ?
#' @param block_size ?
#' @param blocks ?
#' @param flags ?
#' @param generation ?
#' @param access_time ?
#' @param change_time ?
#' @param birth_time ?
#'
#' @return (`data.frame`)
#' @export
#'
#' @family fs
#'
#' @examples
#' file_path <- fs::file_temp(ext = "R")
#' fs::file_create(file_path)
#' print(fs::file_info(file_path))
#'
#' print(FileInfo())
FileInfo <- function(
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
    as_datetime <- function(x) as.POSIXct(as.integer(x), origin = "1970-01-01", tz = "")

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
}
