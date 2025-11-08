#' @title Utility to Clean SUMLEVEL for get_acs_old
#'
#' @description
#'  Utility function used by [get_acs_old()].
#'
#' @details
#'  Interprets as 'bg' any of these:    150, '150', 'blockgroup', 'block group', or 'bg' (or variants, ignoring case) \cr
#'  Interprets as 'tract' any of these: 140, '140', or 'tract' (or variants, ignoring case) \cr
#'  Interprets as 'both' any of these: 'both' or a vector that has both of the above terms (or variants, ignoring case).
#' @param sumlevel Character vector (1+ elements), optional, 'bg' by default. See details above.
#' @return Returns 'both', 'tract', or 'bg' (or stops with error if cannot interpret sumlevel input)
#' @seealso [get_acs_old()] which uses this
#' @export
clean.sumlevel <- function(sumlevel = 'bg') {
  bgfound <- 150 %in% sumlevel |
    any(grepl(
      pattern = 'block group',
      x = sumlevel,
      ignore.case = TRUE
    )) |
    any(grepl(
      pattern = 'blockgroup',
      x = sumlevel,
      ignore.case = TRUE
    )) |
    any(grepl(
      pattern = 'bg',
      x = sumlevel,
      ignore.case = TRUE
    ))
  
  tractfound <-
    140 %in% sumlevel |
    any(grepl(
      pattern = 'tract',
      x = sumlevel,
      ignore.case = TRUE
    ))
  
  if (any(grepl(
    pattern = 'both',
    x = sumlevel,
    ignore.case = TRUE
  ))) {
    bgfound <- TRUE
    tractfound <- TRUE
  }
  
  if (tractfound &  bgfound) {
    sumlevel <- 'both'
  }
  if (tractfound & !bgfound) {
    sumlevel <- 'tract'
  }
  if (!tractfound &  bgfound) {
    sumlevel <- 'bg'
  }
  if (!tractfound &
      !bgfound) {
    stop('Invalid sumlevel specifying resolution needed is tract, bg, or both')
  }
  
  return(sumlevel)
}
