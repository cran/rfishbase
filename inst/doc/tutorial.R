## ----include=FALSE-------------------------------------------------------
knitr::opts_chunk$set(warning=FALSE, comment=NA)

## ----message=FALSE, warning=FALSE, results="hide", eval=FALSE------------
#  install.packages("rfishbase",
#                   repos = c("http://packages.ropensci.org", "http://cran.rstudio.com"),
#                   type="source")

## ----message=FALSE, warning=FALSE, results="hide"------------------------
library("rfishbase")

## ------------------------------------------------------------------------
fish <- c("Oreochromis niloticus", "Salmo trutta")

## ------------------------------------------------------------------------
fish <- validate_names(c("Oreochromis niloticus", "Salmo trutta"))

## ------------------------------------------------------------------------
fish <- species_list(Genus = "Labroides")
fish

## ------------------------------------------------------------------------
fish <- common_to_sci("trout")
fish

## ------------------------------------------------------------------------
species(fish[1:2])

## ------------------------------------------------------------------------
dat <- species(fish, fields=c("SpecCode", "PriceCateg", "Vulnerability"))
dat

## ----eval=FALSE----------------------------------------------------------
#  list_fields("Resilience")

## ------------------------------------------------------------------------
resil <- stocks(fish, fields="Resilience")
merge(dat, resil)

## ----eval=FALSE----------------------------------------------------------
#  options(FISHBASE_API = "http://fishbase.ropensci.org/sealifebase")
#  kingcrab <- common_to_sci("king crab")
#  kingcrab

## ----eval=FALSE----------------------------------------------------------
#  species(kingcrab)
#  ecology(kingcrab)

## ------------------------------------------------------------------------
options(FISHBASE_API = "http://fishbase.ropensci.org")

