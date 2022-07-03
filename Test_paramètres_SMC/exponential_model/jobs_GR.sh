#! /bin/bash

## Author : Lindsay GOULET
## Université Paris-Saclay
## Lab : LISN ~ UMR9015 ~ BIOINFO team

for rep in {1..100}
do
	sbatch k10/exponential_model.sh $rep
	sbatch k21/exponential_model.sh $rep
done
