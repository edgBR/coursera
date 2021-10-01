library(readr)
library(lubridate)
library(logger)
library(dplyr)

read_data <- function(file_path) {
  data_out <-
    tryCatch({
      household_power_consumption <- read_delim(
        file_path,
        ";",
        escape_double = FALSE,
        col_types = cols(
          Date = col_date(format = "%d/%m/%Y"),
          Global_active_power = col_number(),
          Global_intensity = col_number(),
          Global_reactive_power = col_number(),
          Time = col_time(format = "%T"),
          Voltage = col_number()
        ),
        trim_ws = TRUE
      )
    },
    error = function(e) {
      e
    },
    warning = function(w) {
      w
    })
  
  if (inherits(data_out, "error")) {
    log_error(data_out$message)
  } else if (inherits(data_out, "warning")) {
    log_warn(data_out$message)
  } else {
    log_info("Reading {file_path} was successful")
  }
  return(data_out %>% rename_all(tolower)) ## forcing lowercase
}
