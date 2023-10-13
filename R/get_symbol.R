# get_symbols -------------------------------------------------------------

time_interval <- function(interval) {
  data("time_intervals", envir = environment())
  stopifnot(interval %in% names(time_intervals))

  time_intervals[[interval]]
}


date_posixct <- function(date) {
  date %>%
    as.Date() %>%
    as.POSIXct() %>%
    as.numeric() %>%
    trunc()
}


