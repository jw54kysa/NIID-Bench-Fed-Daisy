#!/bin/bash --
#SBATCH --job-name=big_exp_200_4_2
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
  for perm in prob_size
  do
    srun singularity exec FEDDC.sif \
    python3.9 -u experiments.py \
      --model=simple-cnn \
      --dataset=cifar10 \
      --nets_path='results_s1/cifar10/iid-diff-quantity-rand-sb/feddc/prob_size/simple-cnn/experiment-2025-02-22-14:14-20/nets.pkl' \
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
      --partition_path='results/cifar10/iid-diff-quantity-rand-sb/fedavg/simple-cnn/experiment-2025-02-18-15:13-50/partition_tuple.pkl' \
      --beta=0.5 \
      --device='cpu' \
      --datadir='./data/' \
      --logdir='./logs/' \
      --noise=0 \
      --sample=1 \
      --init_seed=0 \
      --experiment_id=%j
  done
done
