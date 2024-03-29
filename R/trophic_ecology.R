#' ecology
#' 
#' @return a table of species ecology data
#' @details By default, will only return one entry (row) per species.  Increase limit to
#' get multiple returns for different stocks of the same species, though often data is either
#' identical to the first or simply missing in the additional stocks. 
#' @inheritParams species
#' @export
#' @references http://www.fishbase.org/manual/english/fishbasethe_ecology_table.htm
#' @examplesIf interactive()
#'
#' \dontrun{
#' ecology("Oreochromis niloticus")
#' 
#' ## trophic levels and standard errors for a list of species
#' ecology(c("Oreochromis niloticus", "Salmo trutta"),
#'         fields=c("SpecCode", "FoodTroph", "FoodSeTroph", "DietTroph", "DietSeTroph"))
#' }
ecology <- endpoint("ecology") 

#ecology <- function(species_list=NULL, fields = NULL,
#                    server = NULL){
#    ecology_endpoint(species_list, fields = fields,  
#                     server = getOption("FISHBASE_API", "fishbase"), 
#                     version = get_latest_release(),
#                     db = default_db())
#}

## This function wants to have custom default for the 'limit' argument.  To do this, first create 
## a function with the generic default using endpoint(), and then use it to define a new function.
## For some reason, `ecology` table often returns additional results with different stockcodes but no
## new data for the species in question.  Should be investigated further.  
ecology_endpoint <- endpoint("ecology") 


#' fooditems
#' 
#' @return a table of species fooditems
#' @inheritParams species
#' @export
#' @references http://www.fishbase.org/manual/english/fishbasethe_food_items_table.htm
#' @examplesIf interactive()
#' \dontrun{
#' fooditems("Oreochromis niloticus")
#' }
fooditems <- endpoint("fooditems")



#' diet_items
#' @param ... additional arguments (not used)
#' @return a table of diet_items
#' @export
#' @examplesIf interactive()
#' \dontrun{
#' diet_items()
#' }
diet_items <- function(...) fb_tbl("diet_items")

#' predators
#'  
#' @return a table of predators
#' @inheritParams species
#' @export
#' @references http://www.fishbase.org/manual/english/fishbasethe_predators_table.htm
#' @examplesIf interactive()
#' \dontrun{
#' predators("Oreochromis niloticus")
#' }
predators <- endpoint("predats")



#' estimate
#'  
#' @return a table of estimates from some models on trophic levels
#' @inheritParams species
#' @export
#' @references http://www.fishbase.us/manual/English/FishbaseThe_FOOD_ITEMS_table.htm
#' @examplesIf interactive()
#' \dontrun{
#' estimate("Oreochromis niloticus")
#' }
estimate <- endpoint("estimate")



#' diet
#'  
#' @return a table of species diet
#' @inheritParams species
#' @export
#' @references http://www.fishbase.org/manual/english/fishbasethe_diet_table.htm
#' @examplesIf interactive()
#' \dontrun{
#' diet()
#' }
diet <- endpoint("diet")


#' popqb
#'  
#' @return a table of species popqb
#' @inheritParams species
#' @export
#' @references http://www.fishbase.org/manual/english/fishbasethe_popqb_table.htm
#' @examplesIf interactive()
#' \dontrun{
#' popqb("Oreochromis niloticus")
#' }
popqb <- endpoint("popqb")


#' ration
#'  
#' @return a table of species ration
#' @inheritParams species
#' @export
#' @references http://www.fishbase.org/manual/english/fishbasethe_ration_table.htm
#' @examplesIf interactive()
#' \dontrun{
#' ration("Oreochromis niloticus")
#' }
ration <- endpoint("ration")


