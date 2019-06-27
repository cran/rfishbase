## ----include=FALSE-------------------------------------------------------
knitr::opts_chunk$set(warning=FALSE, comment=NA)
Sys.setenv(GITHUB_TOKEN=paste0("b2b7441d", "aeeb010b", "1df26f1f6", "0a7f1ed", 
                               "c485e443"))

## ----message=FALSE, warning=FALSE, results="hide", eval=FALSE------------
#  remotes::install_github("ropensci/rfishbase")

## ----message=FALSE, warning=FALSE, results="hide"------------------------
library("rfishbase")
library("dplyr") # convenient but not required

## ------------------------------------------------------------------------
fish <- c("Oreochromis niloticus", "Salmo trutta")

## ------------------------------------------------------------------------
fish <- validate_names(c("Oreochromis niloticus", "Salmo trutta"))

## ------------------------------------------------------------------------
fish <- species_list(Genus = "Labroides")
fish

## ------------------------------------------------------------------------
trout <- common_to_sci("trout")
trout

## ------------------------------------------------------------------------
species(trout$Species)

## ------------------------------------------------------------------------
dat <- species(trout$Species, fields=c("Species", "PriceCateg", "Vulnerability"))
dat

## ------------------------------------------------------------------------
list_fields("Resilience")

## ------------------------------------------------------------------------
stocks(trout$Species, fields=c("Species", "Resilience", "StockDefs"))

## ------------------------------------------------------------------------
available_releases()

## ------------------------------------------------------------------------
options(FISHBASE_VERSION="19.04")

## ------------------------------------------------------------------------
sealife <- load_taxa(server="sealifebase")

## ------------------------------------------------------------------------
sealife %>% filter(Class == "Gastropoda")

## ------------------------------------------------------------------------
species(server="sealifebase")

