#!/bin/bash --
#SBATCH --job-name=e11.seeds
#SBATCH --partition=paul
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=2-00:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=BEGIN,END

 # --daisy_perm=rand \ prob_size

for alg in feddc
do
	for si in 0 1 2
	do 
		srun singularity exec FEDDC.sif \
  		python3.9 -u experiments.py \
    		--model=simple-cnn \
    		--dataset=cifar10 \
    		--alg=$alg \
    		--lr=0.01 \
    		--batch-size=64 \
    		--epochs=5 \
    		--n_parties=100 \
    		--rho=0.9 \
    		--mu=0.01 \
    		--comm_round=50 \
    		--daisy=10 \
    		--daisy_perm=prob_size \
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
