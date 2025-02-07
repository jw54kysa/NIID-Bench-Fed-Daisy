
for perm in prob_size
do
  python -u experiments.py \
      --model=simple-cnn \
      --dataset=mnist \
      --alg=feddc \
      --lr=0.01 \
      --batch-size=64 \
      --epochs=10 \
      --n_parties=10 \
      --rho=0.9 \
      --mu=0.01 \
      --comm_round=10 \
      --daisy=0 \
      --daisy_perm=$perm \
      --partition='iid-diff-quantity' \
      --beta=0.5 \
      --device='mps' \
      --datadir='./data/' \
      --logdir='./logs/' \
      --noise=0 \
      --sample=1 \
      --init_seed=0
done