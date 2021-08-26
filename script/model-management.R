# The model-management.R file is intended to be a scratchpad for doing things
# like defining, submitting, tagging, etc. your models. There is no need to keep
# a "record in code" of these activities because they can all be reconstructed
# later via functions like `run_log()`, as demonstrated in `model-summary.Rmd`
#
# The `Model Management Demo` (rendered from the `model-management-demo.Rmd`
# file) shows code for a range of these activities at different stages in the
# modeling process. It exists purely for reference; the intent is _not_ for you
# to replicate the full narrative.
# https://ghe.metrumrg.com/pages/example-projects/bbr-nonmem-poppk-foce/model-management-demo
#
# This script assumes you have already installed and set up bbi. For details
# on getting set up with bbr, see:
# https://metrumresearchgroup.github.io/bbr/articles/getting-started.html#setup


library(bbr)
library(tidyverse)

# source("functions-model.R")


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

