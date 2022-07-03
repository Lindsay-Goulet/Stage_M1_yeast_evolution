#! /bin/bash

## Author : LIndsay GOULET
## Université Paris-Saclay
## Lab : LISN ~ UMR9015 ~ BIOINFO team

for rep in {1..100}
do
	sbatch EGR/neutral_model.sh $rep
  sbatch 10GR/neutral_model.sh $rep
  sbatch 100GR/neutral_model.sh $rep
  sbatch 1000GR/neutral_model.sh $rep
done
