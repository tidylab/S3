#' @title Events
#' @export
#'
#' @family fs
#'
#' @examples
#' print(ls(events))
events <- new.env()

events$UNSUPPORTED_CASE <- function(name) stop("[\033[31mx\033[39m] ", name, " is unsupported", call. = FALSE)
events$FAILED_FINDING <- function(path) stop("[\033[31mx\033[39m] Failed to find ", path, call. = FALSE)
events$COPIED_FILE <- function(path) message("[\033[32mv\033[39m] Copied ", path)
events$SKIPPED_FILE <- function(path) message("[\033[34mi\033[39m] Skipped ", path)
events$FAILED_REMOVING_FILE <- function(path) stop("[\033[31mx\033[39m] Failed to remove ", path, ": no such file or directory", call. = FALSE)
events$FAILED_REMOVING_DIR <- function(path) stop("[\033[31mx\033[39m] Failed to search directory ", path, ": no such file or directory", call. = FALSE)
