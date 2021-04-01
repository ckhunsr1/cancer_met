is.sequential <- function(x){
  all(diff(x) == rep(1,length(x)-1))
}    
library(readxl)
library(dplyr)
################################################################################################################################################################
##For incidence rate##
################################################################################################################################################################
data <- read_xlsx(path = "/Users/chachritkhun/Desktop/Liu_Labwork/cancer/cancer_met/IncidenceMetsBy1Yr_Cut.xlsx", col_names = FALSE, sheet = 1)
data = as.data.frame(data)
colnames(data) = paste("V", 1:ncol(data), sep = "")

##Filter for cancer types##
name_data = (data[rowSums(is.na(data)) == ncol(data) - 1, ])$V1

##Filter for clean rows##
clean_data = data[rowSums(is.na(data)) == 0, ]

##Example input file to apc function (we will use it as a template)##
input = readRDS("/Users/chachritkhun/Downloads/APC_analysis_20201001_121449.495461_input.rds") ##input to apc##
age_range = 0:85
gap = nrow(clean_data)/length(name_data)

for ( idx in 1:length(name_data) ) {
	input$name = paste("US", name_data[idx], "cancer" ,sep = " ")
  my_data = clean_data[(gap*(idx-1) + 1):(gap*idx), ] %>% select(-c("V1"))
	my_data = mutate_all(my_data, function(x) as.numeric(as.character(x)))
  my_data = my_data[, -c(seq(1, 256, 3), 257, 258)]

  dat_e = my_data[, seq(1, 169, 2)]
  dat_o = my_data[, seq(2, 170, 2)]
  
  format_e = matrix(NA, ncol(dat_e), nrow(dat_e))
  format_o = matrix(NA, ncol(dat_o), nrow(dat_o))
  for (i in 1:nrow(dat_e)){
    for (j in 1:ncol(dat_e)){
      format_e[j,i] = dat_e[i, j]
      format_o[j,i] = dat_o[i, j]
    }
  }
  colnames(format_e)<-NULL
  colnames(format_o)<-NULL
  rownames(format_e)<-NULL
  rownames(format_o)<-NULL
  
  input$events = format_e
  input$offset = format_o
  input$ages = age_range
  input$periods = 2010:2016
  
  save(input, file = paste("~/Desktop/Liu_Labwork/cancer/cancer_met/input/Incidence_", idx, ".RData", sep = ""))
}

map = as.data.frame(cbind("Filename" = paste("Incidence", 1:length(name_data), sep = "_"), "Cancer" = name_data))
write.table(map, "/Users/chachritkhun/Desktop/Liu_Labwork/cancer/cancer_met/Mapping_file.txt",
            col.names = TRUE, row.names = FALSE, sep = "\t", quote = FALSE)
