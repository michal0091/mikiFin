## code to prepare `time_intervals`


mins <- c(1, 1, 2, 5, 15, 30, 60, 90)
min_vals <- paste0(rep(mins, 3), "m")

names(min_vals) <-
  c(
    "1minute",
    paste0(mins[-1], "minutes"),
    "1 minute",
    paste0(mins[-1], " minutes"),
    paste0(mins, " min")
  )

time_intervals <- c(
  daily = "1d",
  weekly = "1wk",
  monthly = "1mo",
  hourly = "1h",
  min_vals
)

write.csv(x = time_intervals, file = "data-raw/time_intervals.csv", row.names = FALSE)

usethis::use_data(time_intervals, overwrite = TRUE, description = "A vector of common time series frequencies used in financial and economic data.")
