#!/bin/bash --
#SBATCH --job-name=e12-small-new
#SBATCH --partition=paul
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=2-00:00:00

 # --daisy_perm=rand \ prob_size

for alg in fedavg
do
	for epoch in 20
	do 
		srun singularity exec FEDDC.sif \
  		python3.9 -u experiments.py \
    		--model=simple-cnn \
    		--dataset=cifar10 \
    		--alg=$alg \
    		--lr=0.001 \
    		--batch-size=4 \
    		--epochs=$epoch \
    		--n_parties=100 \
    		--rho=0.9 \
    		--mu=0.01 \
    		--comm_round=200 \
    		--daisy=10 \
    		--daisy_perm=prob_size \
    		--partition=iid-diff-quantity-rand \
    		--beta=0.5 \
    		--device='cpu' \
    		--datadir='./data/' \
    		--logdir='./logs/' \
    		--noise=0 \
    		--sample=1 \
    		--init_seed=0 \
    		--experiment='E12-small-new'
	done
done
