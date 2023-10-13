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


get_yahoo_url <- function(symbol, from, to, interval) {
  paste0(
    "https://query2.finance.yahoo.com/v8/finance/chart/",
    symbol,
    sprintf(
      "?period1=%.0f&period2=%.0f&interval=%s",
      from,
      to,
      interval
    )
  )
}

