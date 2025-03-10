#!/bin/bash --
#SBATCH --job-name=compare_algs_s2
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
  srun singularity exec FEDDC.sif \
  python3.9 -u experiments.py \
    --model=simple-cnn \
    --dataset=cifar10 \
    --partition_path='results_s1/cifar10/iid-diff-quantity/feddc/prob_size/simple-cnn/experiment-2025-02-23-20:27-16' \
    --alg=$alg \
    --lr=0.01 \
    --batch-size=64 \
    --epochs=10 \
    --n_parties=50 \
    --rho=0.9 \
    --mu=0.01 \
    --comm_round=25 \
    --daisy=10 \
    --daisy_perm=prob_size \
    --partition=iid-diff-quantity \
    --partition_path='results_s1/cifar10/iid-diff-quantity/fedavg/simple-cnn/experiment-2025-02-21-17\:44-37/partition_tuple.pkl' \
    --beta=0.5 \
    --device='cpu' \
    --datadir='./data/' \
    --logdir='./logs/' \
    --noise=0 \
    --sample=1 \
    --init_seed=0
done
