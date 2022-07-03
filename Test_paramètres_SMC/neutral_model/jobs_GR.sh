#! /bin/bash

## Author :
## Université Paris-Saclay
## Lab : LISN ~ UMR9015 ~ BIOINFO team

for rep in {41..60}
do
	#sbatch EGR/EGR_8/neutral_model.sh $rep
	sbatch EGR/EGR_10/neutral_model.sh $rep
	#sbatch EGR/EGR_15/neutral_model.sh $rep
	sbatch EGR/EGR_21/neutral_model.sh $rep
	#sbatch 1000GR/1000GR_8/neutral_model.sh $rep
        #sbatch 1000GR/1000GR_10/neutral_model.sh $rep
        #sbatch 1000GR/1000GR_15/neutral_model.sh $rep
        #sbatch 1000GR/1000GR_21/neutral_model.sh $rep
done

