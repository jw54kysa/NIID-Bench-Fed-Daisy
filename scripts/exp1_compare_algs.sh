#!/bin/bash --
#SBATCH --job-name=e11.seeds
#SBATCH --partition=paul
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=2-00:00:00

 # --daisy_perm=rand \ prob_size

for alg in scaffold
do
	for si in 2
	do 
		srun singularity exec FEDDC.sif \
  		python3.9 -u experiments.py \
    		--model=simple-cnn \
    		--dataset=cifar10 \
    		--alg=$alg \
    		--lr=0.001 \
    		--batch-size=64 \
    		--epochs=10 \
    		--n_parties=100 \
    		--rho=0.9 \
    		--mu=0.01 \
    		--comm_round=50 \
    		--daisy=5 \
    		--daisy_perm=rand \
    		--partition=iid-diff-quantity \
    		--beta=0.5 \
    		--device='cpu' \
    		--datadir='./data/' \
    		--logdir='./logs/' \
    		--noise=0 \
    		--sample=1 \
    		--init_seed=$si \
    		--experiment='E11.seeds'
	done
done
