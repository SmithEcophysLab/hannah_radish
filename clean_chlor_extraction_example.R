## Note: all paths assume that 'hannah_radish' is the root directory

###############################################################################
## Libraries
###############################################################################
library(LeafArea)
library(tidyverse)

###############################################################################
## Load data file with lma data
###############################################################################
#lma_data <- read.csv(#insert LMA data here)

###############################################################################
## Chlorophyll content
###############################################################################
## Load chlorophyll plate reader file. Then, in a step, calculate mean absorbance
## and coefficient of variation at 649 and 665 nm. Acceptable CV values should
## be less than 10%
chlor.files <- list.files(path = "data/chlorophyll/chlorophyll_extraction_data/", 
                          pattern = "\\.csv$", recursive = TRUE,
                          full.names = TRUE)
chlor.files <- setNames(chlor.files, chlor.files)


chlor.df <- lapply(chlor.files, read.delim) %>% 
  reshape::merge_all() %>%
  filter(id != "BLK") %>%
  dplyr::select(rep = id, everything()) %>%
  group_by(rep) %>%
  summarize(abs.649 = mean(blank_abs_649, na.rm = TRUE),
            cv.649 = (sd(blank_abs_649, na.rm = TRUE) / blank_abs_649) * 100,
            abs.665 = mean(blank_abs_665, na.rm = TRUE),
            cv.665 = (sd(blank_abs_665, na.rm = TRUE) / blank_abs_665) * 100)


###############################################################################
## Chlorophyll content
###############################################################################
## Calculate leaf disk area (note that this code does not account for ruler/
## coin envelopes in image)
# ij.path <- "/Applications/ImageJ.app"
# imagepath.disk <- "data/chlorophyll/chlorophyll_leaf_scans/"
# 
# chlor.disk.area <- run.ij(path.imagej = ij.path,
#                           set.directory = imagepath.disk,
#                           distance.pixel = , # insert distance/pixel here
#                           known.distance = 1, low.size = 0.01)
# 
# ## Rename area column, merge into central file
# names(chlor.disk.area)[1:2] <- c("id", "disk.area")
# 
# ## Join leaf disk area with chlorophyll file. Note: will need to do some name
# ## cleaning between files before successful join between chlor.df,
# ## chlor.disk.area, and lma files
# chlorophyll <- chlor.df %>%
#   full_join(chlor.disk.area) %>%
#   full_join(lma) %>%
#   dplyr::select(id, abs.649, abs.665, disk.area, lma) %>%
#   mutate(chlA.ugml = (12.19 * abs.665) - (3.56 * abs.649),
#          chlB.ugml = (21.99 * abs.649) - (5.32 * abs.665),
#          chlA.ugml = ifelse(chlA.ugml < 0, 0, chlA.ugml),
#          chlB.ugml = ifelse(chlB.ugml < 0, 0 , chlB.ugml),
#          chlA.gml = chlA.ugml / 1000000,
#          chlB.gml = chlB.ugml / 1000000,
#          chlA.g = chlA.gml * 10, # extracted in 10mL DMSO
#          chlB.g = chlB.gml * 10, # extracted in 10mL DMSO
#          chlA.gm2 = chlA.g / (disk.area / 10000),
#          chlB.gm2 = chlB.g / (disk.area / 10000),
#          chlA.mmolm2 = chlA.gm2 / 893.51 * 1000,
#          chlB.mmolm2 = chlB.gm2 / 907.47 * 1000,
#          chlA.mmolg = chlA.mmolm2 / lma,
#          chlB.mmolg = chlB.mmolm2 / lma,
#          chl.mmolg = chlA.mmolg + chlB.mmolg,
#          chl.mmolm2 = chlA.mmolm2 + chlB.mmolm2,
#          chlA.chlB = chlA.g / chlB.g) %>%
#   dplyr::select(id, chlA.ugml:chlA.chlB)

## Quick note: Pot number 9 was extracted in 15 mL DMSO instead of 10 mL. This 
## doesn't change anything except for that chlA.g and chlB.g should by multiplied
## by 15 mL insteadl of 10 mL for this single replicate




