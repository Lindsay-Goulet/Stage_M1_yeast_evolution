#!/bin/bash

#SBATCH --job-name=te_EGR
#SBATCH --mem=5GB

source /shared/ifbstor1/software/miniconda/bin/activate slimLindsay2

## Author : Lindsay GOULET
## Université Paris-Saclay
## Lab : LISN ~ UMR9015 ~ BIOINFO team

# Parameters for the simulations

Ne=2000 # Population size
mu=1.67e-8 # Mutation rate : initially 1.67e-10 => rescaled by 1000 factor (identical mu/rho)
rho=0.5e-5 # Recombination rate : initially 0.5e-5 => rescaled by 1000 factor (identical mu/rho)
n=20 # Number of samples

knots=21

rep=$1
for rp in 1 3 6
do
	./smc++ estimate $mu EGR/files/twoepoch_model_$rep.smc.gz -o EGR/EGR_$knots/results/cubic/rp$rp --base $rep --knots $knots --timepoints 0 20000 --spline cubic -rp $rp
	./smc++ plot EGR/EGR_$knots/plot/cubic/rp$rp/plot_model_$rep.png EGR/EGR_$knots/results/cubic/rp$rp/$rep.final.json --csv
	./smc++ estimate $mu EGR/files/twoepoch_model_$rep.smc.gz -o EGR/EGR_$knots/results/piecewise/rp$rp --base $rep --knots $knots --timepoints 0 20000 --spline piecewise -rp $rp
  ./smc++ plot EGR/EGR_$knots/plot/piecewise/rp$rp/plot_model_$rep.png EGR/EGR_$knots/results/piecewise/rp$rp/$rep.final.json --csv

done
