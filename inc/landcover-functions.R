require(foreach)
l4_tab <-
  read.table(
             here::here("gisdata/landcover/lc-l4-table.csv"),
             header = FALSE, sep = ":",
             stringsAsFactors = FALSE, fill = TRUE) |>
  setNames(c("code", "class", "vegetation", "cover", "water", "surface")) |>
  mutate(
         across(.cols =
                  all_of(c("class", "vegetation", "cover", "water", "surface")),
                .fns = trimws))

code2lc <- function(data,years) {
  vars <- expand.grid(i =names(data), years = years)
  foreach(year = vars$years, i = vars$i, .combine = rbind) %do% {
    x <- data[[i]][year]
    y <- data.frame(table(x)) |>
      setNames(c("code", "count"))
    y$code <- as.integer(as.character(y$code))
    y$year <- as.numeric(as.character(year))
    y$patch <- i
    y <- y |> left_join(l4_tab, by = "code")
    return(y)
  }
}