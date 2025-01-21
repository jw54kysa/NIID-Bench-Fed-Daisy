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

for dataset in cifar10
do
  for n_parties in 10 50 100 150
  do
    for part in homo iid-diff-quantity
    do
      python create_partitions.py \
        --dataset=$dataset \
        --n_parties=$n_parties \
        --partition=$part \
        --beta=0.5 \
        --datadir='./data/' \
        --logdir='./logs/'
    done
  done
done