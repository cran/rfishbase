# Morphology and Physiology tables, http://www.fishbase.org/manual/english/fishbasemorphology_and_physiology.htm


#' oxygen
#' 
#' @return a table of species oxygen data
#' @inheritParams species
#' @export
#' @examplesIf interactive()
#'  \dontrun{
#' oxygen("Oreochromis niloticus")
#' }
oxygen <- endpoint("oxygen")

#' morphology
#' 
#' @return a table of species morphology data
#' @inheritParams species
#' @export
#' @examplesIf interactive()
#'  \dontrun{
#' morphology("Oreochromis niloticus")
#' }
morphology <- endpoint("morphdat")

#' morphometrics
#' 
#' @return a table of species morphometrics data
#' @inheritParams species
#' @export
#' @examplesIf interactive()
#' \dontrun{
#' morphometrics("Oreochromis niloticus")
#' }
morphometrics <- endpoint("morphmet")

#' swimming
#' 
#' @return a table of species swimming data
#' @inheritParams species
#' @export
#' @examplesIf interactive() 
#' \dontrun{
#' swimming("Oreochromis niloticus")
#' }
swimming <- endpoint("swimming")

#' speed
#' 
#' @return a table of species speed data
#' @inheritParams species
#' @export
#' @examplesIf interactive()
#' \dontrun{
#' speed("Oreochromis niloticus")
#' }
speed <- endpoint("speed")

#' genetics
#' 
#' @return a table of species genetics data
#' @inheritParams species
#' @export
#' @examplesIf interactive()
#' \dontrun{
#' genetics("Oreochromis niloticus")
#' genetics("Labroides dimidiatus")
#' }
genetics <- endpoint("genetics")
