
# also see  ACSdownload/data-raw/datacreate_lookup.acs.R


# create/save acsdefaultendyearhere (save in package) ####

# cat("may need to do  devtools::load_all() first \n")

acsdefaultendyearhere <- 2023 #  ACSdownload:::guess_end_year() # not exported
#attr(acsdefaultendyearhere, "date_saved_in_package") <- as.character(Sys.Date()) # do not add attributes - leave it as a simple numeric year
usethis::use_data(acsdefaultendyearhere, overwrite = TRUE)


acsfirstyearavailablehere <- 2018 # but might not work anymore prior to 2023 data since formats changed entirely for endyear 2022 and later
usethis::use_data(acsfirstyearavailablehere, overwrite = TRUE)
