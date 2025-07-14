#!/bin/bash --
#SBATCH --job-name=e3
#SBATCH --partition=paul-long
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=3-00:00:00

# --local_epochs_test='sicomb_thresh' \
#      --si_local_epochs=2 \

for alg in fedavg
do
  for si in 2
  do
    srun singularity exec FEDDC.sif \
    python3.9 -u experiments.py \
      --model=simple-cnn \
      --dataset=cifar10 \
      --alg=$alg \
      --lr=0.01 \
      --batch-size=64 \
      --epochs=20 \
      --n_parties=100 \
      --rho=0.9 \
      --mu=0.01 \
      --comm_round=50 \
      --daisy=5 \
      --daisy_perm=rand \
      --partition=mixed-dirichlet \
      --beta=0.5 \
      --device='cpu' \
      --datadir='./data/' \
      --logdir='./logs/' \
      --noise=0 \
      --sample=1 \
      --init_seed=$si \
      --experiment='E3'
  done
done
