import pickle
from utils import *
import argparse
import os
from plots import *

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dataset', type=str, default='mnist', help='dataset used for training')
    parser.add_argument('--partition', type=str, default='homo', help='the data partitioning strategy')
    parser.add_argument('--n_parties', type=int, default=10,  help='number of workers in a distributed cluster') # 2
    parser.add_argument('--batch-size', type=int, default=64, help='input batch size for training (default: 64)')
    parser.add_argument('--beta', type=float, default=0.5,
                        help='The parameter for the dirichlet distribution for data partitioning')

    parser.add_argument('--datadir', type=str, required=False, default="./data/", help="Data directory")
    parser.add_argument('--logdir', type=str, required=False, default="./logs/", help='Log directory path')
    args = parser.parse_args()
    return args

if __name__ == "__main__":
    args = get_args()

    log_path = os.path.join("partitions", args.dataset, str(args.n_parties), args.partition)
    mkdirs(log_path)

    print(">>> Partitioning Data ", log_path)
    X_train, y_train, X_test, y_test, net_dataidx_map, traindata_cls_counts = partition_data(
        args.dataset, args.datadir, args.logdir, args.partition, args.n_parties, log_path, beta=args.beta)

    print(">>> Creating Plot: ", log_path)
    plot_data_dis(net_dataidx_map, log_path, args)