#!/bin/bash --
#SBATCH --job-name=label_dis_test
#SBATCH --partition=clara
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=BEGIN,END

for alg in feddc
do
  for perm in rand
  do
    srun singularity exec FEDDC.sif \
    python3.9 -u experiments.py \
      --model=simple-cnn \
      --dataset=cifar10 \
      --alg=$alg \
      --lr=0.01 \
      --batch-size=64 \
      --epochs=10 \
      --n_parties=50 \
      --rho=0.9 \
      --mu=0.01 \
      --comm_round=20 \
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
