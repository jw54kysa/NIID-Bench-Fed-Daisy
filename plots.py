import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import numpy as np
from collections import Counter
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

    # Bar plot for sample size
    ax1.xaxis.set_major_locator(MaxNLocator(integer=True))
    ax1.bar(np.arange(len(counts)), counts, label='Sample Size', alpha=0.7, color='blue')
    ax1.set_title("Client Sample Size")
    ax1.set_xlabel("Client")
    ax1.set_ylabel("Sample Size", color='blue')
    ax1.tick_params(axis='y', labelcolor='blue')

    if visits is not None:
        # Create second y-axis for visits
        ax2 = ax1.twinx()
        ax2.plot(np.arange(len(visits)), visits, label='Visits', color='red', marker='o')
        ax2.set_ylabel("Visits", color='red')
        ax2.tick_params(axis='y', labelcolor='red')

    # Adding legends for both plots
    fig.legend()

    # Save and display the plot
    plt.savefig(path + "/rss_plt.png")

def plot_data_dis(client_idxs, path, args):

    data = {}
    for idx, l in client_idxs.items():
        train_dl_local, test_dl_local, _, _ = get_dataloader(args.dataset, args.datadir, args.batch_size, 32, l,
                                                             0)
        label_counter = Counter()
        for inputs, clients in train_dl_local:
            # Update the counter with the clients in the current batch
            label_counter.update(clients.tolist())

        # To print the counts of each label
        data[idx] = dict(label_counter)

    clients = list(data.keys())
    categories = set(cat for label in data for cat in data[label].keys())
    category_values = {category: [data[label].get(category, 0) for label in clients] for category in categories}

    client_sums = {client: sum(data[client].values()) for client in clients}

    # Sort the clients list based on the sum of labels for each client
    clients_sorted = sorted(clients, key=lambda client: client_sums[client])

    print(clients)
    print(clients_sorted)

    fig, ax = plt.subplots(figsize=(16, 8))
    # Plot the bars dynamically, stacking them
    bottom = np.zeros(len(clients))  # Initialize bottom at 0 for stacking

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


def calculate_label_distribution(client_idxs, path, args):
    counts = {}
    data = {}
    for idx, l in client_idxs.items():
        sample_size = len(l)
        counts[idx] = sample_size

        train_dl_local, test_dl_local, _, _ = get_dataloader(args.dataset, args.datadir, args.batch_size, 32, l,
                                                             0)
        label_counter = Counter()
        for inputs, labels in train_dl_local:
            # Update the counter with the labels in the current batch
            label_counter.update(labels.tolist())

        # To print the counts of each label
        data[idx] = dict(label_counter)
        print(data[idx])
