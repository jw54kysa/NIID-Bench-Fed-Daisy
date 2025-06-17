
# --partition_path='partitions/cifar10/mixed-dirichlet/100/partition_tuple.pkl' \

for alg in feddc
do
  for perm in rand
  do
    python3 -u experiments.py \
    --model=simple-cnn \
    --dataset=cifar10 \
    --alg=$alg \
    --lr=0.01 \
    --batch-size=64 \
    --epochs=10 \
    --n_parties=50 \
    --rho=0.9 \
    --mu=0.01 \
    --comm_round=10 \
    --daisy=1 \
    --si_local_epochs=0 \
    --local_epochs_test='sicomb' \
    --combined_si_alpha=0.6 \
    --partition=mixed-dirichlet \
    --partition_path='partitions/cifar10/mixed-dirichlet/50/partition_tuple.pkl' \
    --beta=0.8 \
    --device='cpu' \
    --datadir='./data/' \
    --logdir='./logs/' \
    --noise=0 \
    --sample=1 \
    --init_seed=0 \
    --experiment='local'
  done
done