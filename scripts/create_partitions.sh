#!/bin/bash --
#SBATCH --job-name=create_niid_partitions
#SBATCH --partition=clara
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=128G
#SBATCH --time=02:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=BEGIN,END

for dataset in cifar10
do
  for part in mixed-dirichlet #iid-diff-quantity-rand # iid-diff-quantity #iid-diff-quantity-rand-sb noniid-labeldir
  do
    for n_parties in 50
    do
        #srun singularity exec FEDDC.sif \
        python3 -u create_partitions.py \
        --dataset="$dataset" \
        --n_parties=$n_parties \
        --partition="$part" \
        --beta=0.8 \
        --datadir='./data/' \
        --logdir='./logs/'
    done
  done
done
