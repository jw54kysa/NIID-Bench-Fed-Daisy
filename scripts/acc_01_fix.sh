#!/bin/bash --
#SBATCH --job-name=jan_fix_lr
#SBATCH --partition=clara
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=2-00:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=END

for alg in feddc
do
  for perm in rand
  do
    srun singularity exec FEDDC.sif \
    python3.9 -u experiments_old.py \
      --model=simple-cnn \
      --dataset=cifar10 \
      --partition='partitions/cifar10/noniid-labeldir/50/partition_tuple.pkl' \
      --alg=$alg \
      --lr=0.1 \
      --batch-size=64 \
      --epochs=10 \
      --n_parties=50 \
      --rho=0.9 \
      --mu=0.01 \
      --comm_round=25 \
      --daisy=10 \
      --daisy_perm=$perm \
      --partition=noniid-labeldir \
      --beta=0.5 \
      --device='cpu' \
      --datadir='./data/' \
      --logdir='./logs/' \
      --noise=0 \
      --sample=1 \
      --init_seed=0
  done
done
