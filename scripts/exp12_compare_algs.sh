#!/bin/bash --
#SBATCH --job-name=e13
#SBATCH --partition=paul
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=2-00:00:00

 # --daisy_perm=rand \ prob_size

for alg in fedavg
do
	for epoch in 25
	do 
		srun singularity exec FEDDC.sif \
  		python3.9 -u experiments.py \
    		--model=simple-cnn \
    		--dataset=cifar10 \
    		--alg=$alg \
    		--lr=0.01 \
    		--batch-size=64 \
    		--epochs=$epoch \
    		--n_parties=50 \
    		--rho=0.9 \
    		--mu=0.01 \
    		--comm_round=100 \
    		--daisy=10 \
    		--daisy_perm=rand \
    		--partition=iid-diff-quantity-rand-sb \
    		--beta=0.5 \
    		--device='cpu' \
    		--datadir='./data/' \
    		--logdir='./logs/' \
    		--noise=0 \
    		--sample=1 \
    		--init_seed=0 \
    		--experiment='E13'
	done
done
