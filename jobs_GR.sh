#! /bin/bash

## Author :
## Université Paris-Saclay
## Lab : LISN ~ UMR9015 ~ BIOINFO team

for rep in {76..100}
do
	sbatch EGR/neutral_model.sh $rep
  	sbatch 10GR/neutral_model.sh $rep
        sbatch 100GR/neutral_model.sh $rep
        sbatch 1000GR/neutral_model.sh $rep
done

