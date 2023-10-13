# get_symbols -------------------------------------------------------------

time_interval <- function(interval) {
  data("time_intervals", envir = environment())
  stopifnot(interval %in% names(time_intervals))

  time_intervals[[interval]]
}


