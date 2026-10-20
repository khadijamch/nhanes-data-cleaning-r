# Run the installation once
install.packages("haven")

# Load the package each time you start a new session
library(haven)

# Allow extra time for the downloads
options(timeout = 300)

# Import demographic data
demographics <- read_xpt(
  "https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/DEMO_J.xpt"
)

# Import body measurements
measurements <- read_xpt(
  "https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/BMX_J.xpt"
)

# Keep only the columns we need
demo_selected <- demographics[
  , c("SEQN", "RIDAGEYR", "RIAGENDR", "RIDRETH1")
]

body_selected <- measurements[
  , c("SEQN", "BMXHT", "BMXWT")
]

# Match participants using their identifier
combined <- merge(
  demo_selected,
  body_selected,
  by = "SEQN"
)

# Keep adults
adults <- combined[
  !is.na(combined$RIDAGEYR) & combined$RIDAGEYR >= 18,
]

# Create the project dataset
health_data <- data.frame(
  height_cm = as.numeric(adults$BMXHT),
  
  weight_kg = as.numeric(adults$BMXWT),
  
  gender = factor(
    adults$RIAGENDR,
    levels = c(1, 2),
    labels = c("Male", "Female")
  ),
  
  race_ethnicity = factor(
    adults$RIDRETH1,
    levels = c(1, 2, 3, 4, 5),
    labels = c(
      "Mexican American",
      "Other Hispanic",
      "Non-Hispanic White",
      "Non-Hispanic Black",
      "Other race, including multiracial"
    )
  )
)

# Keep participants with all four variables available
health_data <- health_data[complete.cases(health_data), ]

# Open the finished dataset
View(health_data)

# Number of observations: use this result in your paragraph
nrow(health_data)

# Check the variable types
str(health_data)

# Count the categories
nlevels(health_data$gender)
nlevels(health_data$race_ethnicity)

# Check for missing values
colSums(is.na(health_data))


colSums(is.na(health_data))

write.csv(
  health_data,
  "NHANES_adult_height_weight.csv",
  row.names = FALSE
)


