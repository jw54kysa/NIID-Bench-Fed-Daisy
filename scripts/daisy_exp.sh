#!/bin/bash --
#SBATCH --job-name=big_exp_200_5
#SBATCH --partition=paula
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=128G
#SBATCH --time=2-00:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=END

for alg in feddc
do
  for perm in rand
  do
    srun singularity exec FEDDC.sif \
    python3.9 -u experiments.py \
      --model=simple-cnn \
      --dataset=cifar10 \
      --nets_path='results_s1/cifar10/iid-diff-quantity-rand-sb/feddc/rand/simple-cnn/experiment-2025-02-23-20:24-38/nets.pkl' \
      --alg=$alg \
      --lr=0.01 \
      --batch-size=32 \
      --epochs=10 \
      --n_parties=200 \
      --rho=0.9 \
      --mu=0.01 \
      --comm_round=15 \
      --daisy=10 \
      --daisy_perm=$perm \
      --partition=iid-diff-quantity-rand-sb \
      --beta=0.5 \
      --device='cpu' \
      --datadir='./data/' \
      --logdir='./logs/' \
      --noise=0 \
      --sample=1 \
      --init_seed=0
  done
done
