#!/usr/bin/python

## Author : Louis OLLIVIER ~ louis.ollivier@etu.univ-rouen.fr
## Université Paris-Saclay
## Lab : LISN ~ UMR9015 ~ BIOINFO team

# This program will use the .trees files given by SLiM to compute the SFS
# and then do a demography parameters inference with dadi (thanks to this SFS).

import msprime, pyslim, tskit, numpy as np, pandas as pd, sys

rep_nb = int(sys.argv[1])  # Replicate number
n = int(sys.argv[2])  # number of sample (diploïd)
ne = int(sys.argv[3]) # Size of the population
mu = float(sys.argv[4]) # Mutation rate
rho = float(sys.argv[5]) # Recombination rate
output = str(sys.argv[6])
rep="EGR_"+str(rep_nb) # Replicate ID /!\ OUTPUT NAME HERE /!\
print(rep)

##### SAMPLING, ADDING NEUTRAL MUTATION AND GETTING SNP MATRIX #####

ts = pyslim.load(f"100GR/neutral_model_{rep_nb}.trees")

# Recapitate the simulation to provide a “prior history” for the initial generation of the simulation = fully coalesced
tsRecap = ts.recapitate(recombination_rate=rho, Ne=ne) # Crossing over recombination set to 0.

orig_max_roots = max(t.num_roots for t in ts.trees())

recap_max_roots = max(t.num_roots for t in tsRecap.trees())
# ~ print(f"Maximum number of roots before recapitation: {orig_max_roots}\n"
      # ~ f"After recapitation: {recap_max_roots}")
# Simplify to a subset of the population that is still alive and
# returns a simplified tree sequence that retains only the history of the samples.

sampleInds = np.random.choice(tsRecap.individuals_alive_at(0), n, replace=False)

# Get the node of our samples
sampleNodes = []
for i in sampleInds:
   sampleNodes.extend(tsRecap.individual(i).nodes)

tsRecap_Sampled = tsRecap.simplify(sampleNodes) # This return the simplify tree (subtree) for the sampled individuals

# Add neutral mutations (= overlay)
tsRecap_Sampled_Mutated = pyslim.SlimTreeSequence(msprime.mutate(tsRecap_Sampled, rate=(mu), keep=True)) # keep existing mutations

indv_names = ["i"+str(k) for k in range(20)]
with open(output, "w") as vcf_file:
    tsRecap_Sampled_Mutated.write_vcf(vcf_file, individual_names=indv_names)
