
for perm in rand prob_size
do
  python -u experiments.py \
      --model=simple-cnn \
      --dataset=cifar10 \
      --alg=feddc \
      --lr=0.01 \
      --batch-size=64 \
      --epochs=1 \
      --n_parties=10 \
      --rho=0.9 \
      --mu=0.01 \
      --comm_round=5 \
      --daisy 10 \
      --daisy_perm=$perm \
      --partition=iid-diff-quantity \
      --partition_path='partitions/cifar10/100/iid-diff-quantity/partition_tuple.pkl' \
      --beta=0.5 \
      --device='cpu' \
      --datadir='./data/' \
      --logdir='./logs/' \
      --noise=0 \
      --sample=1 \
      --init_seed=0
done