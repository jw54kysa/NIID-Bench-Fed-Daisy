
for alg in all_in
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
    --partition=iid-diff-quantity \
    --partition_path='partitions/cifar10/iid-diff-quantity/50/partition_tuple.pkl' \
    --beta=0.5 \
    --device='cpu' \
    --datadir='./data/' \
    --logdir='./logs/' \
    --noise=0 \
    --sample=1 \
    --init_seed=0 \
    --experiment='test_01_fail'
  done
done