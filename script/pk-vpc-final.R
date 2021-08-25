#' --- 
#' title: VPC with the vpc package
#' output: github_document
#' ---
#' 
#' # Scope
#' 
#' This document illustrates the mechanics of using the vpc package to 
#' get people started. Pred-corrected VPC is only considered for EMA filings, 
#' where the agency prefers pred-correction.
#' 

#' # Required packages
library(tidyverse)
library(yspec)
library(mrgsolve)
library(mrggsave)
library(vpc)
library(glue)

options(mrggsave.dir = "../deliv/figure", mrg.script = "pk-vpc-final.R")

mrg_vpc_theme = new_vpc_theme(list(
  sim_pi_fill = "steelblue3", sim_pi_alpha = 0.5,
  sim_median_fill = "grey60", sim_median_alpha = 0.5
))

#' 
#' The analysis data set
#' 
runno <- "r2"
data <- data.table::fread(here::here("data","dat1.csv"), na=".") %>% 
  ## add columns necessary for mrgsim
  mutate(
    evid=mdv,
    DOSE=ifelse(amt==0,NA_real_,amt),
    cmt=1
  ) %>%
  ## fill DOSE within a subject
  group_by(ID) %>% 
  fill(DOSE, .direction="downup") %>% 
  ungroup()
head(data)

#' # Simulate the vpc
#' 
#' ## Load the mrgsolve model
#' 
#' This should reflect `../model/nonmem/r2.ctl`
mod <- mread(glue("../model/sim/{runno}.cpp"))

#' # Set up the simulation
#' 
#' Create a function to simulate out one replicate
sim <- function(rep, data, model) {
  mrgsim(
    model, 
    data = data,
    carry_out = "DOSE,evid",
    Req = "Y", 
    output = "df", 
    quiet  = TRUE
  ) %>%  mutate(irep = rep)
}

#' Simluate data

#' 200 replicates
isim <- seq(200)

set.seed(86486)
sims <- lapply(
  isim, sim, 
  data = data, 
  mod = mod
) %>% 
  bind_rows() 

sum(sims$Y)

#' Filter both the observed and simulated data
fdata <-  rename(data, id=ID) %>% 
  ## remove dosing rows
  filter(evid == 0)
fsims <- rename(sims, id=ID) %>% 
  ## remove dosing rows
  filter(evid == 0)

#' # Create the plot
#' 
#' Pass observed and simulated data into vpc function
p1 <- vpc(
  obs = fdata,
  sim = fsims,
  obs_cols = list(dv = "dv"),
  sim_cols=list(dv="Y", sim="irep"), 
  log_y = TRUE,
  pi = c(0.05, 0.95),
  ci = c(0.025, 0.975), 
  show = list(obs_dv = TRUE), 
  vpc_theme = mrg_vpc_theme
) 

p1 <- 
  p1 +  
  theme_bw() + 
  xlab("Time (hours)") + 
  ylab("Drugx concentration (mg/mL/mg)")

p1

mrggsave_last(stem = "pk-vpc-{runno}", height = 7.5)
