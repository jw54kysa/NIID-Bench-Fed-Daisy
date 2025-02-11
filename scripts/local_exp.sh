
for perm in prob_size
do
  python -u experiments.py \
    --model=vgg-9 \
    --dataset=cifar10 \
    --alg=feddc \
    --lr=0.01 \
    --batch-size=32 \
    --epochs=10 \
    --n_parties=100 \
    --rho=0.9 \
    --mu=0.01 \
    --comm_round=75 \
    --daisy=10 \
    --daisy_perm=$perm \
    --partition=iid-diff-quantity-rand-sb \
    --beta=0.5 \
    --device='cpu' \
    --datadir='./data/' \
    --logdir='./logs/' \
    --noise=0 \
    --sample=1 \
    --init_seed=1
done