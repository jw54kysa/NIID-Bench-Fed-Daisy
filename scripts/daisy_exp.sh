#!/bin/bash --
#SBATCH --job-name=big_exp_200_fedavg2
#SBATCH --partition=paula
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=128G
#SBATCH --time=2-00:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=END

for alg in fedavg
do
  for perm in rand
  do
    srun singularity exec FEDDC.sif \
    python3.9 -u experiments.py \
      --model=simple-cnn \
      --dataset=cifar10 \
      --alg=$alg \
      --lr=0.01 \
      --batch-size=32 \
      --epochs=100 \
      --n_parties=200 \
      --rho=0.9 \
      --mu=0.01 \
      --comm_round=25 \
      --daisy=0 \
      --daisy_perm=$perm \
      --partition=iid-diff-quantity-rand-sb \
      --partition_path='results/cifar10/iid-diff-quantity-rand-sb/fedavg/simple-cnn/experiment-2025-02-18-15:13-50/partition_tuple.pkl' \
      --beta=0.5 \
      --device='cpu' \
      --datadir='./data/' \
      --logdir='./logs/' \
      --noise=0 \
      --sample=1 \
      --init_seed=0
  done
done
