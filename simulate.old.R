# simulate.R
# R version of Excel sheet HEMAA model_Simulation_17Nov_E.coli
# Feb 2017

simulate = function(pEColiBSIresist){

set.seed(1234) # to avoid getting different answer when re-trying previous resistance level

## common parameters
nPatients = 18934000 
cLife	= 4200000 
cBedDay	= 1839 # Accounting bed day cost
pMort	= 0.107
cOppCost =	216 # Katie's bed day cost
cAccount = 800
tCost = 256.26 # treatment cost

## Bootstrap samples (see Excel sheet 'parameters' for distributions)
n.sims = 100000 # can be large because simulation is simple
rEColiBSI = rbeta(n=n.sims, shape1=2019.032956, shape2=3307871.058) # beta, alpha and beta
##pEColiBSIresist = rbeta(n=n.sims, shape1=108.2166189, shape2=1873.772739) # beta, alpha and beta ## SELECTED BY USER ##
LoSEColiBSI = rgamma(n=n.sims, shape= 4, scale=1/1.25) # gamma
ORmortEColiBSI = exp(rnorm(n=n.sims, mean=0.916290732, sd=0.515888553)) # log normal
#
rEColiResp = rbeta(n=n.sims, shape1=264.7886475, shape2=2941831.295) # beta, alpha and beta
pEColiRespresit = rbeta(n=n.sims, shape1=34.62510699, shape2=306.508952) # beta, alpha and beta
LoSEColiResp = 0 
ORmortEColiResp = 1
#
rEColiUTI = rbeta(n=n.sims, shape1=25752.64952	, shape2=3254839.646) # beta, alpha and beta
pEColiUTIresist = rbeta(n=n.sims, shape1=850.6749156, shape2=17763.65584) # beta, alpha and beta
LoSEColiUTI = 0 
ORmortEColiUTI = 1

## now run the sums
# number with disease
numEColiBSI = rEColiBSI * pEColiBSIresist * nPatients # input from web here
# treatment cost
TreatmentCostBSI = tCost*numEColiBSI # Added March 2017
# Number additional bed days
nBedEColiBSI =  numEColiBSI * LoSEColiBSI
#nBedEColiResp	= numEColiResp * LoSEColiResp
#nBedEColiUTI  = NumEColiUTI * LoSEColiUTI
nBedEColiResp	= 0 # zero because LoSEColiResp is zero
nBedEColiUTI  = 0 # zero because LoSEColiUTI is zero
nBedEColiTotal = nBedEColiBSI	+ nBedEColiResp	+ nBedEColiUTI
# Number additional deaths
nMorrtEColiTotal = numEColiBSI * ( (pMort*ORmortEColiBSI) - pMort)
# Costs
cMortEColiTotal = ifelse(nMorrtEColiTotal>0, nMorrtEColiTotal*cLife, 0)
cBedEColiOppCost = nBedEColiTotal * cOppCost # key output (using Katie's bed day)
cBedEColiTotal = nBedEColiTotal * cBedDay # key output (using accounting cost)
# final cost (using accounting cost)
cEColiTOTAL = cMortEColiTotal + cBedEColiTotal + TreatmentCostBSI #

# return
ret = list()
ret$cBedEColiOppCost = cBedEColiOppCost
ret$cBedEColiTotal = cBedEColiTotal
ret$cEColiTOTAL = cEColiTOTAL
ret$cAccount = cAccount
ret$cOppCost = cOppCost
return(ret)
}