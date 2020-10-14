# ReadExcel.R
# Read in excel results and make R data set for use in shiny app
# Feb 2017
library(readxl)
library(ggplot2)

# read sheet and transform to matrix (note, empty rows are removed)
raw = as.matrix(read_excel('HEMAA model_Simulation_17Nov_E.coli.xlsm', sheet='Simulation sheet', skip=1))

# get the resistance p
pEColiBSIresist = as.numeric(raw[1, 3])
res.frame = data.frame(pEColiBSIresist=pEColiBSIresist, 
  mean = round(as.numeric(raw[2, 30])), # cBedEColiOppCost
  lower = round(as.numeric(raw[3, 30])), 
  upper = round(as.numeric(raw[4, 30])))
sims = data.frame(pEColiBSIresist=pEColiBSIresist,
  vals= as.numeric(raw[5:nrow(raw), 30]))

## dummy additional data
#
temp = res.frame
temp$pEColiBSIresist = temp$pEColiBSIresist - 0.01 
temp$mean = temp$mean * 0.9
temp$lower = temp$lower * 0.9
temp$upper = temp$upper * 0.9
res.frame = rbind(res.frame, temp)
#
temp = sims
temp$pEColiBSIresist = temp$pEColiBSIresist - 0.01 
temp$vals = temp$vals * 0.9
sims = rbind(sims, temp)

# save
save(sims, res.frame, file='FromExcel.RData')
