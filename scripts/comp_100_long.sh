#!/bin/bash --
#SBATCH --job-name=exp0_1_100
#SBATCH --partition=paul-long
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=128G
#SBATCH --time=5-00:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=END

for alg in fedavg #feddc fedprox scaffold fednova moon local_training
do
  srun singularity exec FEDDC.sif \
  python3.9 -u experiments.py \
    --model=simple-cnn \
    --dataset=cifar10 \
    --alg=$alg \
    --lr=0.01 \
    --batch-size=64 \
    --epochs=10 \
    --n_parties=100 \
    --rho=0.9 \
    --mu=0.01 \
    --comm_round=50 \
    --daisy=10 \
    --daisy_perm=rand \
    --partition=iid-diff-quantity \
    --partition_path='partitions/cifar10/100/iid-diff-quantity/partition_tuple.pkl' \
    --beta=0.5 \
    --device='cpu' \
    --datadir='./data/' \
    --logdir='./logs/' \
    --noise=0 \
    --sample=1 \
    --init_seed=0
done
