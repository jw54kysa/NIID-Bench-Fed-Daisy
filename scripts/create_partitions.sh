#!/bin/bash --
#SBATCH --job-name=create_niid_partitions
#SBATCH --partition=paula
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --gpus=a30:4
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=2-00:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=BEGIN,END

for dataset in cifar10
do
  for part in noniid-labeldir
  do
    for n_parties in 50
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