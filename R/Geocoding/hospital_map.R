# Geocoding a csv column of "addresses" in R
# Lib Load ----
if(!require(pacman)) install.packages("pacman")

pacman::p_load(
  # Tidy
  "tidyverse",
  "dbplyr",
  "writexl",
  "readxl",
  
  # Mapping Tools
  "tmaptools",
  "leaflet",
  "ggmap",
  "rgdal",
  "htmltools"
)

# Get File ####
fileToLoad <- file.choose(new = TRUE)

# Read in the CSV data and store it in a variable 
origAddress <- read_csv(fileToLoad, col_names = TRUE)

# Initialize the data frame
geocoded <- data.frame(stringsAsFactors = FALSE)

origAddress <- tribble(
  ~Label, ~Name, ~FullAddress,
  "A","Stony Brook Southampton Hospital","240 Meeting House Ln, Southampton, NY 11968",
  "B","Stony Brook University Hospital","101 Nicolls Road, Stony Brook, NY 11794",
  "C","Stony Brook Eastern Long Island Hosptial","201 Manor Place, Greenport, NY 11944",
  "D","Northwell Health - Southside Hospital","301 East Main Street, Bay Shore, NY 11706",
  "E","Northwell Health - Huntington Hospital","270 Park Avenue, Huntington, NY 11743",
  "F","Northwell Health - Mather Hospital","75 N Country Rd., Port Jefferson, NY 11777",
  "G","CHS - St. Charles","200 Belle Terre Rd., Port Jefferson, NY 11777",
  "H","CHS - St. Catherine of Siena Medical Center","50 NY 25A, Smithtown, NY 11787",
  "I","CHS - Good Smaritan Hospital","1000 Montauk Hwy, West Islip, NY 11795",
  "J","CHS - St. Joseph Hospital","4295 Hempstead Tpke., Bethpage, NY 11714"
  )

# Geocode File ####
for(i in 1:nrow(origAddress)) {
  print(paste("Working on geocoding: ", origAddress$FullAddress[i]))
  if(
    is.null(
      suppressWarnings(
        suppressMessages(
          geocode_OSM(
            origAddress$FullAddress[i]
          )
        )
      )
    )
  ) {
    print(
      paste(
        "Could not get record for: "
        , origAddress$FullAddress[i]
        , ". Trying next record..."
      )
    )
    origAddress$lon[i] <- ''
    origAddress$lat[i] <- ''
  } else {
    print(
      paste(
        "Getting Result For: "
        , origAddress$FullAddress[i]
      )
    )
    result <- geocode_OSM(
      origAddress$FullAddress[i]
      , return.first.only = T
      , as.data.frame = T
    )
    origAddress$lon[i] <- as.numeric(result[3])
    origAddress$lat[i] <- as.numeric(result[2])
  }
}

# Clean up Records ----
# Useful functions
left <- function(text, num_char) {
  substr(text, 1, num_char)
}

mid <- function(text, start_num, num_char) {
  substr(text, start_num, start_num + num_char - 1)
}

right <- function(text, num_char) {
  substr(text, nchar(text) - (num_char-1), nchar(text))
}

origAddress <- origAddress %>%
  filter(Name != "Long Island Community Hospital") %>%
  filter(
    origAddress$lat != "" | origAddress$lon != ""
  ) %>%
  mutate(ZipCode = right(FullAddress, 5))

# Map locations ----
origAddress$lat <- as.numeric(origAddress$lat)
origAddress$lon <- as.numeric(origAddress$lon)

# Get shape files
# USA level zipcode for 2015
file_loc = "S:\\Global Finance\\1 REVENUE CYCLE\\Steve Sanderson II\\ALOS_Readmit_Mapping\\USA_gis_files"
usa <- readOGR(dsn = file_loc, layer = "cb_2015_us_zcta510_500k", encoding = "UTF-8")
dim(usa)
class(usa) # the human data is located at usa@data

# change the column name of the usa@data "ZCTA5CE10" to zipcode
names(usa)[1] = "zipcode"

#url3 = "http://www.unitedstateszipcodes.org/zip_code_database.csv"
file3 <- file.choose(new = TRUE)
file3 <- read.csv(file3)
all_usa_zip <- file3

specific_state <- all_usa_zip %>%
  filter(state == "NY") %>%
  select(zip, primary_city, county)

colnames(specific_state) <- c("zipcode", "City", "County")
specific_state$zipcode <- as.factor(specific_state$zipcode)
specific_state$County <- gsub("County", "", specific_state$County)

state_join <- full_join(usa@data, specific_state)

state_clean <- na.omit(state_join)

STATE_SHP <- sp::merge(x = usa, y = state_clean, all.x = F)
#head(STATE_SHP)
dim(STATE_SHP)

# Join Data ----
location_join <- origAddress
location_join$ZipCode <- as.character(location_join$ZipCode)
joined_data <- inner_join(location_join, state_clean, by = c("ZipCode" = "zipcode"))
head(joined_data)
dim(joined_data)

# Map ----
sv_lng <- -72.97659
sv_lat <- 40.78007
sv_zoom <- 9

# Hosp Marker ----
hospMarker <- makeAwesomeIcon(
  icon = 'glyphicon-plus'
  , markerColor = 'lightblue'
  , iconColor = 'black'
  , library = "glyphicon"
)

l <- leaflet() %>%
  setView(
    lng = sv_lng
    , lat = sv_lat
    , zoom = sv_zoom
    ) %>%
  addTiles(group = "OSM (default)") %>%
  addProviderTiles(
    providers$Stamen.Toner
    , group = "Toner"
    ) %>%
  addProviderTiles(
    providers$Stamen.TonerLite
    , group = "Toner Lite"
    ) %>%
  addControl(
    "My Health Location Map"
    , position = "topright"
    )

l <- l %>%
  addLayersControl(
    baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
    options = layersControlOptions(
      collapsed = TRUE
      , position = "topright"
    )
  )

l <- l %>%
  addAwesomeMarkers(
    lng = sv_lng
    , lat = sv_lat
    , icon = hospMarker
    , label = "LI Community Hospital"
    # , labelOptions = labelOptions(
    #   noHide = FALSE
    #   , direction = "auto"
    #   )
  )

l <- l %>%
  addCircles(
    data = origAddress
    , lat = ~lat
    , lng = ~lon
    , radius = 4
    , fillOpacity = 1
    , label = ~htmlEscape(Label)
    , labelOptions = labelOptions(
      noHide = TRUE
      , direction = "auto"
      )

  )

l

origAddress %>%
  select(Label, Name, FullAddress) %>%
  knitr::kable() %>%
  kableExtra::kable_styling(
    bootstrap_options = c(
      "striped"
      , "hover"
      , "condensed"
      , "responsive"
    )
    , font_size = 12
    , full_width =  TRUE
    , position = "left"
  )

# Clean env ----
rm(list = ls())