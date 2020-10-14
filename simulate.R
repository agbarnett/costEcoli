# simulate.R
# R version of Excel sheet HEMAA model_Simulation_17Nov_E.coli and five other sheets
# Apr 2017

simulate = function(inbug, inresBSI, inresResp, inresUTI){

set.seed(1234) # to avoid getting different answer when re-trying previous resistance level

## common parameters
n.sims = 100000 # can be large because simulation is simple
nPatients = 18934000 
cLife	 = 4200000 
cBedDay	 = 1839 # Accounting bed day cost
cOppCost = 	216 # Katie's bed day cost
cAccount = 800
# things that vary by organism:
if(inbug == 'ecoli'){
 tCost = 256.26 # treatment cost
 pMort = 	0.107 # Probability of mortality after non-resistant infection
 # BSI
 pBSI = rbeta(n = n.sims, shape1 = 2019.032956, shape2 = 3307871.058) # beta; alpha and beta ; probability of infection
 LoSBSI = rgamma(n = n.sims, shape = 6.412068, scale=	0.762625) # gamma; alpha and beta
 RiskMortBSI = exp(rnorm(n = n.sims, mean = 0.48858001, sd=	0.186785126)) # log normal hazard ratio
 # Respiratory
 pResp = rbeta(n = n.sims, shape1 = 264.7886475, shape2 = 	2941831.295) # beta; alpha and beta ; probability of infection
 LoSResp = 0
 RiskMortResp = 0
 # UTI
 pUTI = rbeta(n = n.sims, shape1 = 25752.64952, shape2 = 	3254839.646) # beta; alpha and beta ; probability of infection
 LoSUTI = 0
 RiskMortUTI = 0
} 
if(inbug == 'Klebsiella'){ # same LoS and RiskMort as ecoli
 tCost = 256.26 
 pMort = 	0.135 # Probability of mortality after non-resistant infection
 # BSI
 pBSI = rbeta(n = n.sims, shape1 = 150.1716057, shape2 = 	1046341.854) # beta; alpha and beta; probability of infection
 LoSBSI = rgamma(n = n.sims, shape = 6.412068, scale=	0.762625) # gamma; alpha and beta
 RiskMortBSI = exp(rnorm(n = n.sims, mean = 0.48858001, sd=	0.1867851263)) # log normal
 # Respiratory
 pResp = 0
 LoSResp = 0
 RiskMortResp = 0
 # UTI
 pUTI = 0
 LoSUTI = 0
 RiskMortUTI = 0
} 
if(inbug == 'Pseudomonas'){ # has BSI, Resp and UTI
 tCost = 128.65
 pMort = 	0.184 # Probability of mortality after non-resistant infection
 pBSI = rbeta(n = n.sims, shape1 = 357.147706, shape2 = 3309630.859) # beta, alpha and beta; probability of infection
 LoSBSI = rgamma(n = n.sims, shape = 7.965942, scale=	0.045192) # gamma; alpha and beta
 RiskMortBSI = exp(rnorm(n = n.sims, mean = 0.18232156, sd=	0.220662612)) # log normal
 # Respiratory
 pResp = rbeta(n = n.sims, shape1 = 2387.364078, shape2 = 3298724.47)
 LoSResp = rgamma(n = n.sims, shape = 5.531904, scale=	0.054231) 
 RiskMortResp = exp(rnorm(n = n.sims, mean =0.18232156, sd=	0.103434977)) 	
 # UTI
 pUTI = rbeta(n = n.sims, shape1 = 3396.303175, shape2 = 3291426.335)
 LoSUTI = 0
 RiskMortUTI = 0
} 	
if(inbug == 'MRSA'){
 tCost = 256.26
 pMort = 	0.107 # Probability of mortality after non-resistant infection
 # BSI
 pBSI = rbeta(n = n.sims, shape1 = 1324.442876, shape2 = 	3394682.93) # beta, alpha and beta; probability of infection
 LoSBSI = rgamma(n = n.sims, shape = 0.754867, scale=	3.364832) # gamma
 RiskMortBSI = exp(rnorm(n = n.sims, mean = 0.23111172, sd=	0.219678294)) # log normal
 # Respiratory
 pResp = rbeta(n = n.sims, shape1 = 1535.932686	, shape2 = 	3337448.166) # beta, alpha and beta; probability of infection
 LoSResp = rgamma(n = n.sims, shape = 5.531904	, scale = 	0.108461752) # gamma
 RiskMortResp = exp(rnorm(n = n.sims, mean = -0.916290732	, sd = 0.103434977)) # log normal
 # UTI
 pUTI = rbeta(n = n.sims, shape1 = 847.7536667	, shape2 = 		3259743.272) # beta, alpha and beta; probability of infection
 pUTI = 0
 LoSUTI = 0
 RiskMortUTI = 0
} 
if(inbug == 'VRE'){
 tCost = 1622.19
 pMort = 	0.107 # Probability of mortality after non-resistant infection
 # BSI
 pBSI = rbeta(n = n.sims, shape1 = 66.55605653, shape2 = 3286652.285) # beta, alpha and beta
 LoSBSI = rgamma(n = n.sims, shape = 3.058924402, scale = 	1.598601128) # gamma
 RiskMortBSI = exp(rnorm(n = n.sims, mean = 0.943905899, sd = 	0.063360523)) # log normal
 # Respiratory
 pResp = 0
 LoSResp = 0
 RiskMortResp = 0
 # UTI
 pUTI = rbeta(n = n.sims, shape1 = 368.3142479, shape2 = 3284632.113)	
 LoSUTI = rgamma(n = n.sims, shape = 0.009471988 , scale = 		190.0340281) # gamma
 RiskMortUTI = 0 # no additional mortality risk
} 

## Bootstrap samples (see Excel sheet 'parameters' for distributions)

## now run the sums
# number of resistant infections (BSI, Resp, UTI), input from web here (inres = resistance probability)
numBSIInfections = round(pBSI * inresBSI * nPatients) # 
numRespInfections = round(pResp * inresResp * nPatients) # 
numUTIInfections = round(pUTI * inresUTI * nPatients) # 
numInfections = numBSIInfections + numRespInfections + numUTIInfections # total infections
# Number additional bed days
nBedBSI = numBSIInfections * LoSBSI
nBedResp = numRespInfections * LoSResp
nBedUTI = numUTIInfections * LoSUTI
nBed = nBedBSI + nBedResp + nBedUTI # total bed days
# Number additional deaths
# TO DO, check same baseline prob of death? - don't worry for now, not using death
# does this equation work for HR?- don't worry for now, not using death
# hazard ratios
if(inbug %in% c('ecoli','Klebsiella','Pseudomonas','MRSA')){ # same LoS and RiskMort as ecoli
  nMorrBSI = numBSIInfections * ( (pMort*RiskMortBSI) - pMort)
  nMorrResp = numRespInfections * ( (pMort*RiskMortResp) - pMort)
  nMorrUTI = numUTIInfections * ( (pMort*RiskMortUTI) - pMort)
}
# odds ratios
if(inbug %in% c('VRE')){ # same LoS and RiskMort as ecoli
  nMorrBSI = numBSIInfections * ( ((pMort*RiskMortBSI)/(pMort*RiskMortBSI+1-pMort)) - pMort)
  nMorrResp = numRespInfections * ( ((pMort*RiskMortResp)/(pMort*RiskMortResp+1-pMort)) - pMort)
  nMorrUTI = numUTIInfections * ( ((pMort*RiskMortUTI)/(pMort*RiskMortUTI+1-pMort)) - pMort)
}
# total deaths:
nMorr = nMorrBSI + nMorrResp + nMorrUTI 

## Costs of treatment
# All treatment costs are for BSI only (across all organisms)
cTreatment = tCost * numBSIInfections # column AI

cMort = ifelse(nMorr>0, nMorr*cLife, 0)
cBedOppCost = nBed * cOppCost # key output (using Katie's bed day)
cBedAccount = nBed * cBedDay # key output (using accounting cost)

# return
ret = list()
ret$cOppCost = cOppCost
ret$cAccount = cAccount
ret$tCost = tCost
#ret$cMort = cMort
ret$cBedAccount = cBedAccount + cTreatment # Bed and treatment
ret$cBedOppCost = cBedOppCost + cTreatment # Bed and treatment
ret$cTreatment = cTreatment
return(ret)
}