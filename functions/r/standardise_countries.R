
standardise_countries <- function(dt,varname){
        # dont want any capitals...
        dt[,paste(varname) := tolower(get(varname))]
        
        dt[,paste(varname) := case_when(str_detect(get(varname),"brunei")~"brunei"
                         ,str_detect(get(varname),"verde")~"capo verde"
                         ,str_detect(get(varname),"congo dr")~"dr congo"
                         ,str_detect(get(varname),"ivoire")~"ivory coast"
                         ,get(varname) == "korea dpr"~"north korea"
                         ,get(varname) == "korea republic"~"south korea"
                         ,str_detect(get(varname),"hong kong") ~ "hong kong"
                         ,str_detect(get(varname),"czech") ~ "czechia"
                         ,str_detect(get(varname),"gambia") ~ "gambia"
                         ,str_detect(get(varname),"new zealand") ~ "new zealand"
                         ,str_detect(get(varname),"macedonia") ~ "north macedonia"
                         ,str_detect(get(varname),"turkey|türkiye") ~ "turkiye"
                         
                         ,str_detect(get(varname),"vincent")~"saint vincent"
                         ,str_detect(get(varname),"st\\.")~str_replace_all(get(varname),"st\\.","saint")
                         ,str_detect(get(varname),"iran")~"iran"
                         ,str_detect(get(varname),"kyrgyz")~"kyrgyzstan"
                         ,str_detect(get(varname),"szã©kely land")~"swaziland"
                         ,str_detect(get(varname),"united states")~"usa"
                         ,str_detect(get(varname),"united states virgin islands")~"us virgin islands"
                         ,str_detect(get(varname),"taipei|taiwan") ~ "taiwan"
                         ,TRUE~get(varname)
                         )]

        return(dt)
}

