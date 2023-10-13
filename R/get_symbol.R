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

extract_jason <- function(yahoo_url) {
  res <-
    httr::GET(yahoo_url)
  httr::stop_for_status(res)
  data <- httr::content(res, as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()
  data$chart$result
}


get_symbols <- function(symbols, from, to, frequency) {
  interval <- time_interval(interval = frequency)
  min_frequency <- !(interval %in% c("1d", "1wk", "1mo"))

  # meter excepción minutos

  from_posixct <- date_posixct(from)
  to_posixct <- date_posixct(to)


  url <- get_yahoo_url(symbols, from_posixct, to_posixct, interval)


}
