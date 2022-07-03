#!/bin/bash

#SBATCH --job-name=10GR
#SBATCH --mem=5GB

source /shared/ifbstor1/software/miniconda/bin/activate slimLindsay2

## Author : Lindsay GOULET
## Université Paris-Saclay
## Lab : LISN ~ UMR9015 ~ BIOINFO team


## This script will launch the SLiM simulations that will generate tree sequence and then
## use dadi (in Python) to do the inference of the two demography parameters for the given model.

# Parameters for the simulations

Ne=2000 # Population size
mu=1.67e-8 # Mutation rate : initially 1.67e-10 => rescaled by 1000 factor (identical mu/rho)
rho=0.5e-5 # Recombination rate : initially 0.5e-5 => rescaled by 1000 factor (identical mu/rho)
n=20 # Number of samples

rep=$1

# Run the SLiM simulation : generate a .trees file (= a tree sequence)

echo "Simu SLiM no° $rep"
slim -d Ne=$Ne -d rho=$rho -d rep=$rep 10GR/neutral_model.slim

# Run the Python script : compute SFS, do the demography parameters inference and save them in a file

python3 10GR/demography_inference.py $rep $n $Ne $mu $rho 10GR/neutral_model_$rep.vcf

# Delete all the temporary files
rm 10GR/neutral_model_${rep}.trees

# Compression du fichier vcf
bgzip 10GR/neutral_model_$rep.vcf
tabix 10GR/neutral_model_$rep.vcf.gz

## Utilisation de SMC++
mv 10GR/neutral_model_* 10GR/files

./smc++ vcf2smc 10GR/files/neutral_model_$rep.vcf.gz 10GR/files/neutral_model_$rep.smc.gz 1 p1:i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19 --length 10000000

./smc++ estimate $mu 10GR/files/neutral_model_$rep.smc.gz -o 10GR/results --base $rep --knots 10 --timepoints 0 10000 --spline cubic -rp 3

./smc++ plot 10GR/plot/plot_model_$rep.png 10GR/results/$rep.final.json --csv
