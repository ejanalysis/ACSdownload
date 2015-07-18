#' @export
clean.sumlevel <- function(sumlevel='bg') {
  
  bgfound <- 150 %in% sumlevel | 
    any(grepl(pattern = 'block group', x = sumlevel, ignore.case = TRUE)) | 
    any(grepl(pattern = 'blockgroup', x = sumlevel, ignore.case = TRUE)) | 
    any(grepl(pattern = 'bg', x = sumlevel, ignore.case = TRUE))
  
  tractfound <- 140 %in% sumlevel | any(grepl(pattern = 'tract', x = sumlevel, ignore.case = TRUE))
  
  if (any(grepl(pattern = 'both', x = sumlevel, ignore.case = TRUE))) {bgfound <- TRUE; tractfound <- TRUE} 

  if ( tractfound &  bgfound) {sumlevel <- 'both'}
  if ( tractfound & !bgfound) {sumlevel <- 'tract'}
  if (!tractfound &  bgfound) {sumlevel <- 'bg'}
  if (!tractfound & !bgfound) {stop('Invalid sumlevel specifying resolution needed is tract, bg, or both')}
  
  return(sumlevel)
}
