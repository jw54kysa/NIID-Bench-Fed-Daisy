#!/bin/bash --
#SBATCH --job-name=e4-mnist
#SBATCH --partition=paul
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=2-00:00:00

# --local_epochs_test='sicomb_thresh' \
#      --combined_si_alpha=1.0 \
#      --si_local_epochs=9.71 \

for alg in feddc
do
  for si in 0
  do
    srun singularity exec FEDDC.sif \
    python3.9 -u experiments.py \
      --model=simple-cnn \
      --dataset=mnist \
      --alg=$alg \
      --lr=0.01 \
      --batch-size=64 \
      --epochs=10 \
      --n_parties=100 \
      --rho=0.9 \
      --mu=0.01 \
      --comm_round=50 \
      --daisy=5 \
      --daisy_perm=rand \
      --local_epochs_test='sicomb_thresh' \
      --si_local_epochs=2.45 \
      --combined_si_alpha=0.5 \
      --partition=mixed-dirichlet \
      --beta=0.5 \
      --device='cpu' \
      --datadir='./data/' \
      --logdir='./logs/' \
      --noise=0 \
      --sample=1 \
      --init_seed=$si \
      --experiment='E4-mnist'
  done
done
