## code to prepare `time_intervals`

min <- c(1, 1, 2, 5, 15, 30, 60, 90)
min_vals <- paste0(rep(min, 3), "m")

names(min_vals) <-
  c(
    "1minute",
    paste0(mins[-1], "minutes"),
    "1 minute",
    paste0(mins[-1], " minutes"),
    paste0(mins, " min")
  )

c(
  daily = "1d",
  weekly = "1wk",
  monthly = "1mo",
  hourly = "1h",
  min_vals
)


usethis::use_data(time_intervals, overwrite = TRUE)
