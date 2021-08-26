# This script assumes you have already installed and set up bbi. For details
# on getting set up with bbr, see:
# https://metrumresearchgroup.github.io/bbr/articles/getting-started.html#setup


library(bbr)
library(tidyverse)

# define model dir and load tags
MODEL_DIR <- here::here("model","nonmem")

# bbi_init(.dir = MODEL_DIR,            # the directory to create the bbi.yaml in
#          .nonmem_dir = "/opt/NONMEM", # location of NONMEM installation
#          .nonmem_version = "nm74gf")  # default NONMEM version to use

## update data file and rerun model
# data <- data.table::fread(here("data","dat1.csv"), na=".")
# data1 <- mutate(data, NUM=row_number())
# PKPDmisc::write_nonmem(data1, here::here("data","dat1.csv"))

# mod <- new_model(file.path(MODEL_DIR, "r2"))
mod <- read_model(file.path(MODEL_DIR, "r2"))
submit_model(mod, .mode="local", .bbi_args = list(overwrite=TRUE))

