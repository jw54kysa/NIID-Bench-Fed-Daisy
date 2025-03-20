import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import numpy as np
from collections import Counter
from scipy.stats import chisquare
from utils import *

# PLOT SAMPLE SIZE AND VISITS
def plot_rss_visits(client_idxs, visits, path):

    counts = [0 for _ in range(len(client_idxs))]
    for idx, l in client_idxs.items():
        counts[idx] = len(l)

    fig, ax1 = plt.subplots(figsize=(16, 8))

    if visits is not None:
        combined = sorted(zip(counts, visits.values()), key=lambda x: x[0])
        sorted_counts, sorted_visits = zip(*combined)

        counts = list(sorted_counts)
        visits = list(sorted_visits)

    ax1.xaxis.set_major_locator(MaxNLocator(integer=True))
    ax1.bar(np.arange(len(counts)), counts, label='Sample Size', alpha=0.7, color='blue')
    ax1.set_title("Client Sample Size")
    ax1.set_xlabel("Client")
    ax1.set_ylabel("Sample Size", color='blue')
    ax1.tick_params(axis='y', labelcolor='blue')

    if visits is not None:
        ax2 = ax1.twinx()
        ax2.plot(np.arange(len(visits)), visits, label='Visits', color='red', marker='o')
        ax2.set_ylabel("Visits", color='red')
        ax2.tick_params(axis='y', labelcolor='red')

    fig.legend()

    plt.savefig(path + "/rss_plt.png")

def plot_data_dis(client_idxs, path, args):

    data = {}
    for idx, l in client_idxs.items():
        train_dl_local, test_dl_local, _, _ = get_dataloader(args.dataset, args.datadir, args.batch_size, 32, l,
                                                             0)
        label_counter = Counter()
        for inputs, clients in train_dl_local:
            label_counter.update(clients.tolist())

        data[idx] = dict(label_counter)

    clients = list(data.keys())
    categories = set(cat for label in data for cat in data[label].keys())
    category_values = {category: [data[label].get(category, 0) for label in clients] for category in categories}

    client_sums = {client: sum(data[client].values()) for client in clients}

    clients_sorted = sorted(clients, key=lambda client: client_sums[client])

    print(clients)
    print(clients_sorted)

    fig, ax = plt.subplots(figsize=(16, 8))
    bottom = np.zeros(len(clients))

    sorted_categories = sorted(category_values.items(), key=lambda x: x[1])

    for category in categories:
        values = category_values[category]
        val = [values[clients.index(client)] for client in clients_sorted]
        ax.bar(np.arange(len(clients)), val, bottom=bottom, label=category)
        bottom += np.array(val)  # Update the bottom for the next category

    # Adding clients and title
    ax.set_xlabel('Client')
    ax.set_ylabel('Sample Size')
    ax.set_title('Sample Size & Label Distribution per Client')
    ax.legend()

    plt.savefig(path + "/rss_plt_niid.png")

# Plot Label Distribution and Sampling Index Chi Stat
def plot_data_dis_sample_index(client_idxs, path, args):
    label_distribution = {}
    data = {}
    for idx, l in client_idxs.items():
        train_dl_local, test_dl_local, _, _ = get_dataloader(args.dataset, args.datadir, args.batch_size, 32, l,
                                                             0)
        label_counter = Counter()
        for inputs, clients in train_dl_local:
            label_counter.update(clients.tolist())

        data[idx] = dict(label_counter)

        # compare distributions
        all_label = range(0, 10)
        client_label_dis = [dict(label_counter).get(label, 0) for label in all_label]

        gesamt_summe = sum(client_label_dis)
        gleichverteilung = [gesamt_summe / len(client_label_dis)] * len(client_label_dis)

        # Chi-Quadrat-Test
        chi_stat, p_value = chisquare(f_obs=client_label_dis, f_exp=gleichverteilung)

        label_distribution[idx] = (chi_stat, np.log(chi_stat))

    clients = list(data.keys())
    categories = set(cat for label in data for cat in data[label].keys())
    category_values = {category: [data[label].get(category, 0) for label in clients] for category in categories}

    client_sums = {client: sum(data[client].values()) for client in clients}

    clients_sorted = sorted(clients, key=lambda client: label_distribution[client][0])

    fig, ax1 = plt.subplots(figsize=(16, 8))
    bottom = np.zeros(len(clients))

    sorted_categories = sorted(category_values.items(), key=lambda x: x[1])

    label_distribution_sorted = [label_distribution[client] for client in clients_sorted]

    for category in categories:
        values = category_values[category]
        val = [values[clients.index(client)] for client in clients_sorted]
        ax1.bar(np.arange(len(clients)), val, bottom=bottom, label=category)
        bottom += np.array(val)

    ax2 = ax1.twinx()
    ax2.plot(np.arange(len(label_distribution_sorted)), label_distribution_sorted, label='Sample Index', color='black', marker='o')
    ax2.set_ylabel("Sample Index Label Distribution", color='black')
    ax2.tick_params(axis='y', labelcolor='black')

    # Adding clients and title
    ax1.set_xlabel('Client')
    ax1.set_ylabel('Sample Size')
    ax1.set_title('Sample Size & Label Distribution per Client')
    ax1.legend()

    plt.savefig(path + "/rss_plt_niid_sample_index.png")

    return label_distribution
