#!/bin/bash --
#SBATCH --job-name=ldt_2
#SBATCH --partition=paul-long
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=6-00:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=END

# --si_local_epochs=0 \
#--local_epochs_test='thresh' \

for alg in feddc
do
  for si in 0
  do
    srun singularity exec FEDDC.sif \
    python3.9 -u experiments.py \
      --model=simple-cnn \
      --dataset=cifar10 \
      --partition='partitions/cifar10/noniid-labeldir/100/partition_tuple.pkl' \
      --alg=$alg \
      --lr=0.01 \
      --batch-size=64 \
      --epochs=30 \
      --n_parties=100 \
      --rho=0.9 \
      --mu=0.01 \
      --comm_round=25 \
      --daisy=10 \
      --daisy_perm=rand \
      --si_local_epochs=1 \
      --local_epochs_test='thresh' \
      --partition=noniid-labeldir \
      --beta=0.5 \
      --device='cpu' \
      --datadir='./data/' \
      --logdir='./logs/' \
      --noise=0 \
      --sample=1 \
      --init_seed=0 \
      --experiment='fixed_30'
  done
done
