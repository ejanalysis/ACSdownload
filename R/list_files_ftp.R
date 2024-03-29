#' list_files_ftp
#' Attempt to get list of filenames on an FTP site
#' @param url URL
#' @param credentials empty
#' @param sleep NA
#' @param sort FALSE
#' @param verbose FALSE
#'
#' @return file names
#' @export
#'
list_files_ftp <- function(url, credentials = "", sleep = NA, sort = FALSE, verbose = FALSE) {
  require(magrittr)
  # Do
  x <- url %>%
    purrr::map(
      ~list_files_ftp_worker(
        url = .,
        credentials = credentials,
        sleep = sleep,
        verbose = verbose
      )
    ) %>%
    purrr::flatten_chr()

  # Sort remote file names
  if (sort) x <- sort(x)

  return(x)

}


#' list_files_ftp_worker
#' Attempt to get list of filenames on an FTP site. See list_files_ftp()
#' Uses RCurl::getURL(url, dirlistonly = TRUE)
#' @param url URL
#' @param credentials  ?
#' @param sleep ?
#' @param verbose ?
#'
#' @return list of file names
#' @export
#'
list_files_ftp_worker <- function(url, credentials, sleep, verbose) {

  # Message to user
  if (verbose) message(date_message(), "`", url, "`...")

  # url must be prefixed with ftp or sftp
  if (!grepl("^ftp://|^sftp://", url)) {
    stop("URL must be prefixed with 'ftp://' or 'sftp://'", call. = FALSE)
  }

  # Ensure the directory has a trailing separator
  url <- stringr::str_c(url, .Platform$file.sep)

  # Get the file list
  # If credentials are blank, this will still work
  file_list <- tryCatch({

    RCurl::getURL(
      url,
      userpwd = credentials,
      ftp.use.epsv = FALSE,
      dirlistonly = TRUE,
      forbid.reuse = TRUE,
      .encoding = "UTF-8"
    )

  }, error = function(e) {
    as.character()
  })

  # Make a vector
  if (length(file_list) != 0) {
    file_list <- stringr::str_c(url, stringr::str_split(file_list, "\n")[[1]])
    file_list <- stringr::str_trim(file_list)
  }

  if (!is.na(sleep[1])) Sys.sleep(sleep)

  return(file_list)

}
