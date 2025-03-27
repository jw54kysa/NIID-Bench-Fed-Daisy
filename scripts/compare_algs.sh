#!/bin/bash --
#SBATCH --job-name=comp_long
#SBATCH --partition=paul
#SBATCH -N 1
#SBATCH --ntasks=1
#SBATCH --mem=128G
#SBATCH --time=2-00:00:00
#SBATCH -o log/%x.out-%j
#SBATCH -e log/%x.error-%j
#SBATCH --mail-type=END

for alg in fedavg
do
  srun singularity exec FEDDC.sif \
  python3.9 -u experiments.py \
    --model=simple-cnn \
    --dataset=cifar10 \
    --nets_path='results_long/cifar10/iid-diff-quantity-rand/fedavg/simple-cnn/experiment-2025-03-20-20:21-58/nets.pkl' \
    --alg=$alg \
    --lr=0.01 \
    --batch-size=16 \
    --epochs=10 \
    --n_parties=200 \
    --rho=0.9 \
    --mu=0.01 \
    --comm_round=100 \
    --daisy=10 \
    --daisy_perm=prob_size \
    --partition=iid-diff-quantity-rand \
    --beta=0.5 \
    --device='cpu' \
    --datadir='./data/' \
    --logdir='./logs/' \
    --noise=0 \
    --sample=1 \
    --init_seed=0
done
