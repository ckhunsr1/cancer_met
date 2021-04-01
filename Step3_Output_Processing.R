.libPaths("/storage/home/cxk502/work/R_library/")
library(dplyr)

type = "Incidence"
pheno_list = c(1:17)

for ( pheno in pheno_list ) {

	load(paste("/gpfs/group/dxl46/default/private/poom/apc_met/output/", type, "/", type, "_", pheno, "_output.RData", sep = ""))

	##Create desired output tables##
	m.rose.total = rbind(m.rose, m.rose.all)
	m.ie.total = rbind(m.ie, m.ie.all)
	m.rose.total$Age = as.character(m.rose.total$Age)
	m.ie.total$Age = as.character(m.ie.total$Age)

	##Re-order data##
	m.rose.total$id = paste(m.rose.total$Age, m.rose.total$Year, m.rose.total$Cohort, sep = "_")
	m.ie.total$id = paste(m.ie.total$Age, m.ie.total$Year, m.ie.total$Cohort, sep = "_")
	m.ie.total = m.ie.total[match(m.rose.total$id, m.ie.total$id), ]

	m.rose.total = m.rose.total %>% select(-c("id"))
	m.ie.total = m.ie.total %>% select(-c("id"))

	result = data.frame()
	for ( n in 1:nrow(m.rose.total) ) {
		if ( m.rose.total$Year[n] > 2015.5 ) {
			print(n)
			##Calculate confidence interval via percentile interval (1000 bootstraps)##
			m.rose.sort = sort(m.rose.total[n, 5:ncol(m.rose.total)])
			m.ie.sort = sort(m.ie.total[n, 5:ncol(m.ie.total)])
			
			result_temp = as.data.frame(cbind("Period" = m.rose.total[n,1], "Cohort" = m.rose.total[n,2], "Age" = m.rose.total[n,3], 
					    "Rate_rose" = m.rose.total[n,4], "Rate_upper_rose" = m.rose.sort[0.975*(ncol(m.rose.total) - 4)], 
					    "Rate_lower_rose" = m.rose.sort[0.025*(ncol(m.rose.total) - 4)],
					    "Rate_arima" = m.ie.total[n,4], "Rate_upper_arima" = m.ie.sort[0.975*(ncol(m.rose.total) - 4)], 
					    "Rate_lower_arima" = m.ie.sort[0.025*(ncol(m.rose.total) - 4)]))
			colnames(result_temp) = c("Period", "Cohort", "Age", "Rate_rose", "Rate_upper_rose", "Rate_lower_rose",
						  "Rate_arima", "Rate_upper_arima", "Rate_lower_arima")
			result = rbind(result, result_temp)
		} else {
			print(n)
			result_temp = as.data.frame(cbind("Period" = m.rose.total[n,1], "Cohort" = m.rose.total[n,2], "Age" = m.rose.total[n,3],
	                                    "Rate_rose" = m.rose.total[n,4], "Rate_upper_rose" = NA, "Rate_lower_rose" = NA,
	                                    "Rate_arima" = m.ie.total[n,4], "Rate_upper_arima" = NA, "Rate_lower_arima" = NA), stringsAsFactors = FALSE)
	                colnames(result_temp) =	c("Period", "Cohort", "Age", "Rate_rose", "Rate_upper_rose", "Rate_lower_rose",
	                                          "Rate_arima", "Rate_upper_arima", "Rate_lower_arima")
			result = rbind(result, result_temp)
		}
	}
	result$Period = floor(as.numeric(as.character(result$Period)))
	result$Age = factor(result$Age, levels = c("All", as.character(seq(0.5, 84.5, 1))))
	levels(result$Age) = c("All", as.character(seq(0, 84, 1)))
	result = result[order(result$Age), ]	
	result = result %>% select(-c("Rate_arima", "Rate_upper_arima", "Rate_lower_arima"))

	write.table(result, paste("/gpfs/group/dxl46/default/private/poom/apc_met/output/", type, "/", type, "_", pheno, "_output.txt", sep = ""), col.names = TRUE, row.names = FALSE, sep = "\t", quote = FALSE)

}
