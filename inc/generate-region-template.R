template <- "
---
title: \"%s\"
params:
 cellcode: %s
execute:
 eval: false
 echo: false
 warning: false
 message: false
---

## Location 

{{< include _read-spatial-data.qmd >}}

## Summary for the region of interest (cell)

{{< include _cell-summary.qmd >}}

## Summary for the TEC polygons

{{< include _imap-summary.qmd >}}
"

here::i_am("inc/generate-region-template.R")
library(sf)
slc_aoo <- st_read(
    here::here("gisdata/TEC/Swamps-Fleurieu-IM_AOO.gpkg"),
    quiet = TRUE) |> 
    st_drop_geometry()
for (j in 1:20) {
    filename <- sprintf("results/cell-%s.qmd", slc_aoo[j,"id"])
    cat(
        sprintf(template, slc_aoo[j,"name"], slc_aoo[j,"id"]), file = here::here(filename)
    )
}
