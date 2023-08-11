library(R.matlab)
library(abind)
library(circular)
library(imager)
library("writexl")
library("readxl")
# READ ME: First you need to set the full path to where your sheet lives (the freqband_PAC_metrics_complete)
sheet_path = "C:/Users/ch220650/PAC_3.31.2023/results/"
# read in excel sheet
setwd(sheet_path)
my_data <- read_excel(paste0(sheet_path,"freqband_PAC_metrics_complete.xlsx"))
# get group vector
groups <- my_data$Group_Num;
# pull the relevant subset of columns to looks at (PAC strength and Phase Bias)
sub_col <- c(grep("Strength", colnames(my_data), value = TRUE),grep("Bias", colnames(my_data), value = TRUE));

#initialize data frame which will hold significance values
df = data.frame(matrix(nrow = 0, ncol = length(sub_col)));

for (i in 1:length(colnames(df))){
  print(i)
  curr_colname <- (sub_col)[i]
  curr_vals <- my_data[[curr_colname]]
  if (isTRUE((grep("Strength",curr_colname))==1)){
    colnames(df)[i] <- paste(curr_colname,'w')
    df[['test_sig',paste(curr_colname,'w')]] = (t.test (curr_vals ~ groups, var.equal=TRUE, data = df)$p.value < .05)*1
    df[['test_sig_value',paste(curr_colname,'w')]] = (t.test (curr_vals ~ groups, var.equal=TRUE, data = df)$p.value)
    df[['test_statistic',paste(curr_colname,'w')]] = (t.test (curr_vals ~ groups, var.equal=TRUE, data = df)$statistic)
   } else if (isTRUE((grep("Bias_NoCircMean",curr_colname))==1)){
      colnames(df)[i] <- paste(curr_colname,'w')
      df[['test_sig',paste(curr_colname,'w')]] = (t.test (curr_vals ~ groups, var.equal=TRUE, data = df)$p.value < .05)*1
      df[['test_sig_value',paste(curr_colname,'w')]] = (t.test (curr_vals ~ groups, var.equal=TRUE, data = df)$p.value)
      df[['test_statistic',paste(curr_colname,'w')]] = (t.test (curr_vals ~ groups, var.equal=TRUE, data = df)$statistic)
  } else if (isTRUE((grep("Bias",curr_colname)==1))) {
    colnames(df)[i] <- paste(curr_colname,'w')
  df[['test_sig',paste(curr_colname,'w')]] <- (watson.wheeler.test(curr_vals,groups)$p.value < 0.05)*1
  df[['test_sig_value',paste(curr_colname,'w')]] <- (watson.wheeler.test(curr_vals,groups)$p.value)
  df[['test_sig_value',paste(curr_colname,'w')]] <- (watson.wheeler.test(curr_vals,groups)$statistic)}
}
df <- cbind(" "=rownames(df), df)
write_xlsx(df,"PAC_strength_and_biases_stats.xlsx")