#!/bin/bash --
#SBATCH --job-name=create_niid_partitions
#SBATCH --partition=paul
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=2-00:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=BEGIN,END

for dataset in mnist
do
  for part in iid-diff-quantity-rand
  do
    for n_parties in 200
    do
      srun singularity exec --nv FEDDC.sif \
	python3.9 -u create_partitions.py \
        --dataset=$dataset \
        --n_parties=$n_parties \
        --partition=$part \
        --beta=0.5 \
        --datadir='./data/' \
        --logdir='./logs/'
    done
  done
done
