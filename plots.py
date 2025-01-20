import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import numpy as np
from collections import Counter
from utils import *

# Plot random size client samples
def plot_rss(client_idxs, visits, path, args):
    counts = {}
    data = {}
    for idx, l in client_idxs.items():
        counts[idx] = len(l)

        train_dl_local, test_dl_local, _, _ = get_dataloader(args.dataset, args.datadir, args.batch_size, 32, l,
                                                             0)
        label_counter = Counter()
        for inputs, labels in train_dl_local:
            # Update the counter with the labels in the current batch
            label_counter.update(labels.tolist())

        # To print the counts of each label
        data[idx] = dict(label_counter)

    labels = list(data.keys())
    categories = set(cat for label in data for cat in data[label].keys())
    category_values = {category: [data[label].get(category, 0) for label in labels] for category in categories}

    fig, ax = plt.subplots(figsize=(16, 8))
    # Plot the bars dynamically, stacking them
    bar_width = 0.5
    bottom = np.zeros(len(labels))  # Initialize bottom at 0 for stacking

    for category in categories:
        values = category_values[category]
        ax.bar(np.arange(len(labels)), values, bar_width, bottom=bottom, label=category)
        bottom += np.array(values)  # Update the bottom for the next category

    # Adding labels and title
    ax.set_xlabel('Client')
    ax.set_ylabel('Sample Size')
    ax.set_title('Sample Size & Label Distribution per Client')
    ax.legend()

    plt.savefig(path + "/rss_plt_niid.png")

    #combined = sorted(zip(counts, visits), key=lambda x: x[0])

    # Separate the sorted lists
    #sorted_counts, sorted_visits = zip(*combined)

    # Convert back to lists
    #counts = list(sorted_counts)
    #visits = list(sorted_visits)

    fig, ax1 = plt.subplots(figsize=(16, 8))

    # Bar plot for sample size
    ax1.xaxis.set_major_locator(MaxNLocator(integer=True))
    ax1.bar(np.arange(len(counts)), counts.values(), label='Sample Size', alpha=0.7, color='blue')
    ax1.set_title("Client Sample Size")
    ax1.set_xlabel("Client")
    ax1.set_ylabel("Sample Size", color='blue')
    ax1.tick_params(axis='y', labelcolor='blue')

    # Create second y-axis for visits
    # ax2 = ax1.twinx()
    # ax2.plot(np.arange(len(visits)), visits, label='Visits', color='red', marker='o')
    # ax2.set_ylabel("Visits", color='red')
    # ax2.tick_params(axis='y', labelcolor='red')

    # Adding legends for both plots
    fig.legend()

    # Save and display the plot
    plt.savefig(path + "/rss_plt.png")
