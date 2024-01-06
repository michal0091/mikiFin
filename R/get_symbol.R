# get_symbols -------------------------------------------------------------

#' time_interval
#' @description Select the time interval to be used in the query
#'
#' @param interval Admitted values are 'daily', 'weekly', 'monthly', 'hourly'
#'
#' @keywords internal
time_interval <- function(interval) {
  data("time_intervals", envir = environment())
  stopifnot(interval %in% names(time_intervals))

  time_intervals[[interval]]
}

#' date_posixct
#' @description Converts a date to POSIXct numeric
#'
#' @param date A date format.
#'
#' @keywords internal
date_posixct <- function(date) {
  date %>%
    as.Date() %>%
    as.POSIXct() %>%
    as.numeric() %>%
    trunc()
}


#' get_yahoo_url
#' @description Build the url to query yahoo finance
#'
#' @param symbol character value with the symbol to be queried
#' @param from date from which the data will be queried
#' @param to date to which the data will be queried
#' @param interval time interval to be used in the query
#'
#' @keywords internal
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

#' extract_jason
#' @description Extract the data from the jason file
#'
#' @param yahoo_url url with the data to be extracted
#'
#' @return a data.table with the data extracted
#' @keywords internal
extract_jason <- function(yahoo_url) {
  res <-
    httr::GET(yahoo_url)
  httr::stop_for_status(res)
  data <- httr::content(res, as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()
  data$chart$result
}


#' get_symbols
#' @description Get the data from yahoo finance
#'
#' @param symbols character vector with the symbols to be queried
#' @param from character date from which the data will be queried
#' @param to character date to which the data will be queried
#' @param frequency character value with the frequency to be used in the query
#' @details
#'  Parameter frequency: Admitted values are 'daily', 'weekly', 'monthly', 'hourly'
#' @return a data.table with the data extracted
#' @export
#'
#' @import data.table
#' @import httr
#' @import jsonlite
#'
#' @examples \dontrun{get_symbols(c("AAPL", "MSFT"), "2019-01-01", "2019-12-31", "daily")}
get_symbols <- function(symbols, from, to, frequency) {
  interval <- time_interval(interval = frequency)
  min_frequency <- !(interval %in% c("1d", "1wk", "1mo"))

  # meter excepción minutos

  from_posixct <- date_posixct(from)
  to_posixct <- date_posixct(to)


  lapply(symbols, function(symbol) {

    url <- get_yahoo_url(symbol, from_posixct, to_posixct, interval)
    data <- extract_jason(url)

    t_zone <- data$meta$exchangeTimezoneName
    currency <- data$meta$currency

    data.table(
      symbol = symbol,
      date = data$timestamp[[1]],
      open = data$indicators$quote[[1]]$open[[1]],
      high = data$indicators$quote[[1]]$high[[1]],
      low = data$indicators$quote[[1]]$low[[1]],
      close = data$indicators$quote[[1]]$close[[1]],
      adj_close = data$indicators$adjclose[[1]]$adjclose[[1]],
      volume = data$indicators$quote[[1]]$volume[[1]],
      t_zone = t_zone,
      currency = currency
    ) %>%
      .[, date := as.POSIXct(date, origin = "1970-01-01", tz = t_zone)] %>%
      .[, date := as.Date(date)] %>%
      .[order(symbol, date)]

  }) %>%
    rbindlist()

}
