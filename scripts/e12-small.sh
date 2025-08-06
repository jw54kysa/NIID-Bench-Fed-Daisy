#!/bin/bash --
#SBATCH --job-name=e12-very-small
#SBATCH --partition=paul
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=2-00:00:00

 # --daisy_perm=rand \ prob_size

for alg in feddc
do
	for epoch in 1
	do 
		srun singularity exec FEDDC.sif \
  		python3.9 -u experiments.py \
    		--model=simple-cnn \
    		--dataset=cifar10 \
    		--alg=$alg \
    		--lr=0.01 \
    		--batch-size=4 \
    		--epochs=$epoch \
    		--n_parties=500 \
    		--rho=0.9 \
    		--mu=0.01 \
    		--comm_round=200 \
    		--daisy=20 \
    		--daisy_perm=rand \
    		--partition=iid-diff-quantity-rand \
    		--beta=0.5 \
    		--device='cpu' \
    		--datadir='./data/' \
    		--logdir='./logs/' \
    		--noise=0 \
    		--sample=1 \
    		--init_seed=0 \
    		--experiment='E12-very-small'
	done
done
