
for alg in fedavg feddc
do
  python experiments.py --model=simple-cnn \
    --dataset=cifar10 \
    --alg=$alg \
    --lr=0.01 \
    --batch-size=64 \
    --epochs=10 \
    --n_parties=10 \
    --rho=0.9 \
    --mu=0.01 \
    --comm_round=50 \
    --daisy 10 \
    --partition=noniid-labeldir \
    --beta=0.5\
    --device='cuda:0'\
    --datadir='./data/' \
    --logdir='./logs/' \
    --noise=0\
    --sample=0\
    --init_seed=0
done
