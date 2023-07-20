library(readr)
library(dplyr)

###Lobbyin.txt
headers <- c("Uniqid","Registrant_raw", "Registrant","Isfirm","Client_raw","Client","Ultorg","Amount","Catcode","Source","Self","IncludeNSFS","Use","Ind","Year","Type","Typelong","Affiliate")
parent_directory <- "Your directory here"

df <- read_delim(paste0(parent_directory, "Lobby/lob_lobbying.txt"), delim = ",", col_names = headers, quote = "|")
write.csv(df, file = paste0(parent_directory, "Lobby/Lobbying_all.csv"), row.names = FALSE)

### Lobbyist.txt
headers_2 <- c("Uniqid", "Lobbyist_raw", "Lobbyist", "Lobbyist_id", "Year", "OfficialPosition", "CID", "Formercongmem")
df_2 <- read_delim(paste0(parent_directory, "Lobby/lob_lobbyist.txt"), delim = ",", col_names = headers_2, quote = "|")
write.csv(df_2, file = paste0(parent_directory, "Lobby/Lobbyist_all.csv"), row.names = FALSE)

### Bills.txt
headers_3 <- c("B_ID", "SI_ID", "CongNo", "Bill_Name")
df_3 <- read_delim(paste0(parent_directory, "Lobby/lob_bills.txt"), delim = ",", col_names = headers_3, quote = "|")
write.csv(df_3, file = paste0(parent_directory, "Lobby/Bills_all.csv"), row.names = FALSE)

### Agency.txt
headers_4 <- c("Uniqid", "AgencyID", "Agency")
df_4 <- read_delim(paste0(parent_directory, "Lobby/lob_agency.txt"), delim = ",", col_names = headers_4, quote = "|")
write.csv(df_4, file = paste0(parent_directory, "Lobby/Agencies_all.csv"), row.names = FALSE)

### Indus.txt
headers_5 <- c("Client", "Sub", "Total", "Year", "Catcode")
df_5 <- read_delim(paste0(parent_directory, "Lobby/lob_indus.txt"), delim = ",", col_names = headers_5, quote = "|")
write.csv(df_5, file = paste0(parent_directory, "Lobby/Industries_all.csv"), row.names = FALSE)

### Issue.txtx
headers_6 <- c("SI_ID", "Uniqid", "IssueID", "Issue", "SpecificIssue", "Year")
df_6 <- read_delim(paste0(parent_directory, "Lobby/lob_issue.txt"), delim = ",", col_names = headers_6, quote = "|")
write.csv(df_6, file = paste0(parent_directory, "Lobby/Issues_all.csv"), row.names = FALSE)

# Read Lobbyin.txt
Lobbying <- read.csv(paste0(parent_directory, "Lobby/Lobbying_all.csv"))

# Read Lobbyist.txt
Lobbyist <- read.csv(paste0(parent_directory, "Lobby/Lobbyist_all.csv"))

# Read Bills.txt
Bills <- read.csv(paste0(parent_directory, "Lobby/Bills_all.csv"))

# Read Agency.txt
Agencies <- read.csv(paste0(parent_directory, "Lobby/Agencies_all.csv"))

# Read Indus.txt
Industries <- read.csv(paste0(parent_directory, "Lobby/Industries_all.csv"))

# Read Issue.txtx
Issues <- read.csv(paste0(parent_directory, "Lobby/Issues_all.csv"))

####Merging data sets
merged_df <- inner_join(df, df_4, by = "Uniqid")
merged_df_2 <- inner_join(df_6, df_3, by = "SI_ID")
merged_df_3 <- inner_join(merged_df, merged_df_2, by = "Uniqid")

df <- df[order(df$Registrant), ]
merged_df <- merged_df[order(merged_df$Registrant), ]

#######PAC DATA IMPORTING

#################################################################
###Candidates data

# Define the parent directory
parent_directory_pac <- paste0(parent_directory, "Campaign Finance Data")

# List all subdirectories within the parent directory
subdirectories <- list.dirs(parent_directory_pac, recursive = FALSE)

# Recursive function to search for files with specific pattern
search_files <- function(directory, pattern) {
  files <- list.files(directory, recursive = TRUE, full.names = TRUE)
  files <- files[grepl(pattern, files)]
  return(files)
}

# Define the pattern to match file names
file_pattern <- "cands[0-9]{2}\\.txt"

# Get the file paths for all matching files
file_paths <- search_files(parent_directory_pac, file_pattern)

# Initialize an empty list to store the data frames
data_list <- list()
header <- c(
  "Cycle",
  "FECCandID",
  "CID",
  "FirstLastP",
  "Party",
  "DistIDRunFor",
  "DistIDCurr",
  "CurrCand",
  "CycleCand",
  "CRPICO",
  "RecipCode",
  "NoPacs"
)

# Loop through each file path
for (file_path in file_paths) {
  # Import the TXT file and store it in the data list
  data <- read_delim(file_path, delim = ",", col_names = header, quote = "|")  # Adjust read.table options if needed
  data_list[[file_path]] <- data
}

# Combine all data frames into a single data frame
combined_data <- do.call(rbind, data_list)

# Reset the row names if needed
rownames(combined_data) <- NULL

write.csv(combined_data, file = paste0(parent_directory_pac, "/Candidates_all.csv"), row.names = FALSE)

#################################################################

#################################################################
###PACS to Candidates data

# Define the parent directory
parent_directory_pac <- paste0(parent_directory, "Campaign Finance Data")

# List all subdirectories within the parent directory
subdirectories <- list.dirs(parent_directory_pac, recursive = FALSE)

# Recursive function to search for files with specific pattern
search_files <- function(directory, pattern) {
  files <- list.files(directory, recursive = TRUE, full.names = TRUE)
  files <- files[grepl(pattern, files)]
  return(files)
}

# Define the pattern to match file names
file_pattern <- "pacs[0-9]{2}\\.txt"

# Get the file paths for all matching files
file_paths <- search_files(parent_directory_pac, file_pattern)

# Initialize an empty list to store the data frames
data_list <- list()
header_2 <- c(
  "Cycle",
  "FECRecNo",
  "PACID",
  "CID",
  "Amount",
  "Date",
  "RealCode",
  "Type",
  "DI",
  "FECCandID"
)

# Loop through each file path
for (file_path in file_paths) {
  # Import the TXT file and store it in the data list
  data <- read_delim(file_path, delim = ",", col_names = header_2, quote = "|")  # Adjust read.table options if needed
  data_list[[file_path]] <- data
}

# Combine all data frames into a single data frame
combined_data_2 <- do.call(rbind, data_list)

# Reset the row names if needed
rownames(combined_data_2) <- NULL

write.csv(combined_data_2, file = paste0(parent_directory_pac, "/PACS_to_Candidates_all.csv"), row.names = FALSE)

#################################################################

#################################################################
###PACS to PACS data

# Define the parent directory
parent_directory_pac <- paste0(parent_directory, "Campaign Finance Data")

# List all subdirectories within the parent directory
subdirectories <- list.dirs(parent_directory_pac, recursive = FALSE)

# Recursive function to search for files with specific pattern
search_files <- function(directory, pattern) {
  files <- list.files(directory, recursive = TRUE, full.names = TRUE)
  files <- files[grepl(pattern, files)]
  return(files)
}

# Define the pattern to match file names
file_pattern <- "pac_other[0-9]{2}\\.txt"

# Get the file paths for all matching files
file_paths <- search_files(parent_directory_pac, file_pattern)

# Initialize an empty list to store the data frames
data_list <- list()
header_3 <- c(
  "Cycle",
  "FECRecNo",
  "Filerid",
  "DonorCmte",
  "ContribLendTrans",
  "City",
  "State",
  "Zip",
  "FECOccEmp",
  "Primcode",
  "Date",
  "Amount",
  "RecipID",
  "Party",
  "Otherid",
  "RecipCode",
  "RecipPrimcode",
  "Amend",
  "Report",
  "PG",
  "Microfilm",
  "Type",
  "RealCode",
  "Source"
)

# Loop through each file path
for (file_path in file_paths) {
  # Import the TXT file and store it in the data list
  data <- read_delim(file_path, delim = ",", col_names = header_3, quote = "|")  # Adjust read.table options if needed
  data_list[[file_path]] <- data
}

# Combine all data frames into a single data frame
combined_data_3 <- do.call(rbind, data_list)

# Reset the row names if needed
rownames(combined_data_3) <- NULL

write.csv(combined_data_3, file = paste0(parent_directory_pac, "/PACS_to_PACS_all.csv"), row.names = FALSE)

#################################################################

#################################################################
###FECs Committees data

# Define the parent directory
parent_directory_pac <- paste0(parent_directory, "Campaign Finance Data")

# List all subdirectories within the parent directory
subdirectories <- list.dirs(parent_directory_pac, recursive = FALSE)

# Recursive function to search for files with specific pattern
search_files <- function(directory, pattern) {
  files <- list.files(directory, recursive = TRUE, full.names = TRUE)
  files <- files[grepl(pattern, files)]
  return(files)
}

# Define the pattern to match file names
file_pattern <- "cmtes[0-9]{2}\\.txt"

# Get the file paths for all matching files
file_paths <- search_files(parent_directory_pac, file_pattern)

# Initialize an empty list to store the data frames
data_list <- list()
header_4 <- c(
  "Cycle",
  "CmteID",
  "PACShort",
  "Affiliate",
  "Ultorg",
  "RecipID",
  "RecipCode",
  "FECCandID",
  "Party",
  "PrimCode",
  "Source",
  "Sensitive",
  "Foreign",
  "Active"
)

# Loop through each file path
for (file_path in file_paths) {
  # Import the TXT file and store it in the data list
  data <- read_delim(file_path, delim = ",", col_names = header_4, quote = "|")  # Adjust read.table options if needed
  data_list[[file_path]] <- data
}

# Combine all data frames into a single data frame
combined_data_4 <- do.call(rbind, data_list)

# Reset the row names if needed
rownames(combined_data_4) <- NULL

write.csv(combined_data_4, file = paste0(parent_directory_pac, "/FEC_Committees_all.csv"), row.names = FALSE)

#################################################################

#################################################################
###Individual Contributions data

# Define the parent directory
parent_directory_pac <- paste0(parent_directory, "Campaign Finance Data")

# List all subdirectories within the parent directory
subdirectories <- list.dirs(parent_directory_pac, recursive = FALSE)

# Recursive function to search for files with specific pattern
search_files <- function(directory, pattern) {
  files <- list.files(directory, recursive = TRUE, full.names = TRUE)
  files <- files[grepl(pattern, files)]
  return(files)
}

# Define the pattern to match file names
file_pattern <- "indivs[0-9]{2}\\.txt"

# Get the file paths for all matching files
file_paths <- search_files(parent_directory_pac, file_pattern)

# Initialize an empty list to store the data frames
data_list <- list()
header_5 <- c(
  "Cycle",
  "FECTransID",
  "ContribID",
  "Contrib",
  "RecipID",
  "Orgname",
  "UltOrg",
  "RealCode",
  "Date",
  "Amount",
  "Street",
  "City",
  "State",
  "Zip",
  "RecipCode",
  "Type",
  "CmteID",
  "OtherID",
  "Gender",
  "Microfilm",
  "Occupation",
  "Employer",
  "Source"
)

# Loop through each file path
for (file_path in file_paths) {
  # Import the TXT file and store it in the data list
  data <- read_delim(file_path, delim = ",", col_names = header_5, quote = "|")  # Adjust read.table options if needed
  data_list[[file_path]] <- data
}

# Combine all data frames into a single data frame
combined_data_5 <- do.call(rbind, data_list)

# Reset the row names if needed
rownames(combined_data_5) <- NULL

write.csv(combined_data_5, file = paste0(parent_directory_pac, "/Ind_Contributions_all.csv"), row.names = FALSE)

#################################################################

FEC_Committes <- read.csv(paste0(parent_directory_pac, "/FEC_Committees_all.csv"))
PACS_to_PACS <- read.csv(paste0(parent_directory_pac, "/PACS_to_PACS_all.csv"))
PACS_to_Candidates <- read.csv(paste0(parent_directory_pac, "/PACS_to_Candidates_all.csv"))
Candidates <- read.csv(paste0(parent_directory_pac, "/Candidates_all.csv"))

merged_df <- inner_join(FEC_Committes, PACS_to_Candidates, by = c("CmteID" = "PACID"))

# The rest of the code remains
