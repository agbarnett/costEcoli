# sums.R
# sums and multiplications from Excel sheet
# Feb 2017

# number with disease
numEColiBSI = rEColiBSI * pEColiBSIresist * nPatients # input from web here
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
# final cost
cEColiTOTAL = cMortEColiTotal + cBedEColiTotal # 
