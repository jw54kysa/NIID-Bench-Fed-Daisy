#!/bin/bash --
#SBATCH --job-name=niid-bench-feddc
#SBATCH --partition=paula
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --gpus=a30:4
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=2-00:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=BEGIN,END

for alg in fedavg feddc
do
  python experiments.py --model=simple-cnn \
    --dataset=cifar10 \
    --alg=$alg \
    --lr=0.01 \
    --batch-size=64 \
    --epochs=10 \
    --n_parties=10 \
    --rho=0.9 \
    --mu=0.01 \
    --comm_round=50 \
    --daisy 10 \
    --daisy_perm='rand' \
    --partition=iid-diff-quantity \
    --beta=0.5\
    --device='cuda:0'\
    --datadir='./data/' \
    --logdir='./logs/' \
    --noise=0\
    --sample=1\
    --init_seed=0
done
