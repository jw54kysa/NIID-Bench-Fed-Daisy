#!/bin/bash --
#SBATCH --job-name=vgg9_test
#SBATCH --partition=paula
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=128G
#SBATCH --time=2-00:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=BEGIN,END

for alg in feddc
do
  for perm in rand #prob_size
  do
    srun singularity exec FEDDC.sif \
    python3.9 -u experiments.py \
      --model=vgg-9 \
      --dataset=cifar10 \
      --alg=$alg \
      --lr=0.01 \
      --batch-size=32 \
      --epochs=10 \
      --n_parties=50 \
      --rho=0.9 \
      --mu=0.01 \
      --comm_round=50 \
      --daisy=10 \
      --daisy_perm=$perm \
      --partition=iid-diff-quantity-rand-sb \
      --beta=0.5 \
      --device='cpu' \
      --datadir='./data/' \
      --logdir='./logs/' \
      --noise=0 \
      --sample=1 \
      --init_seed=1
  done
done
