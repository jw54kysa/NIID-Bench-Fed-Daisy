import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import numpy as np
from collections import Counter
from scipy.stats import chisquare
from scipy.special import rel_entr
from sympy.physics.quantum.gate import normalized
from utils import *

# Creates plot for permutation visits
def plot_permutation_visits(client_idxs, visits, path):

    counts = [0 for _ in range(len(client_idxs))]
    for idx, l in client_idxs.items():
        counts[idx] = len(l)

    fig, ax1 = plt.subplots(figsize=(10, 4))

    if visits is not None:
        combined = sorted(zip(counts, visits.values()), key=lambda x: x[0])
        sorted_counts, sorted_visits = zip(*combined)

        counts = list(sorted_counts)
        visits = list(sorted_visits)

    ax1.xaxis.set_major_locator(MaxNLocator(integer=True))
    ax1.bar(np.arange(len(counts)) + 1, counts, alpha=0.7, color='blue')
    ax1.set_xlabel("Clients", fontsize=14)
    ax1.set_ylabel("Datensatzgröße", color='blue', fontsize=14)
    ax1.tick_params(axis='y', labelcolor='blue')

    if visits is not None:
        ax2 = ax1.twinx()
        ax2.plot(np.arange(len(visits)) + 1, visits, label='Visits', color='red', marker='o')
        ax2.set_ylabel("Visits", color='red', fontsize=14)
        ax2.tick_params(axis='y', labelcolor='red')

    fig.legend()
    plt.tight_layout()
    plt.savefig(path + "/permutation_visits.png", dpi=300)

# Creates several plots with data distribution and sample index
def print_plot(path, label_distribution, data):
    clients = list(data.keys())

    # categories
    categories = set(cat for label in data for cat in data[label].keys())
    category_values = {category: [data[label].get(category, 0) for label in clients] for category in categories}

    for appendix in ['_sample_size', '_chi2', '_kl_div', '_combined', '_kl_and_combined']:

        # Sorting
        # (chi2, normal_chi2, kl, normal_kl, combined)
        if appendix == '_sample_size':
            sorting_idx = None
        elif appendix == '_chi2':
            sorting_idx = 1
        elif appendix == '_kl_div':
            sorting_idx = 3
        elif appendix == '_combined':
            sorting_idx = 4
        elif appendix == '_kl_and_combined':
            sorting_idx == 4
        else:
            sorting_idx = None

        if sorting_idx is not None:
            clients_sorted = sorted(clients, key=lambda client: label_distribution[client][sorting_idx])
        else:
            client_sums = {client: sum(data[client].values()) for client in clients}
            clients_sorted = sorted(clients, key=lambda client: client_sums[client])

        # FIG
        fig, ax1 = plt.subplots(figsize=(10, 4))
        bottom = np.zeros(len(clients))

        for category in categories:
            values = category_values[category]
            val = [values[clients.index(client)] for client in clients_sorted]
            ax1.bar(np.arange(len(clients)) + 1, val, bottom=bottom, label=category)
            bottom += np.array(val)

        if appendix in ['_chi2']:
            normalized_chi2_sorted = [label_distribution[client][sorting_idx] for client in clients_sorted]
            ax2 = ax1.twinx()
            ax2.plot(np.arange(len(normalized_chi2_sorted)) + 1, normalized_chi2_sorted, label=r"$SI^{\chi^2}$",
                     color='red',
                     marker='o')
            if appendix == '_chi2':
                ax2.set_ylabel(r"$SI^{\chi^2}$", color='red', fontsize=14)
                ax2.tick_params(axis='y', labelcolor='red')
            ax2.legend(loc='upper left')

        if appendix in ['_kl_div', '_kl_and_combined']:
            normalized_kl_sorted = [label_distribution[client][3] for client in clients_sorted]
            ax2 = ax1.twinx()
            ax2.plot(np.arange(len(normalized_kl_sorted)) + 1, normalized_kl_sorted, label=r"$SI^{KL}$",
                     color='blue',
                     marker='o')
            if appendix == '_kl_div':
                ax2.set_ylabel(r"$SI^{KL}$", color='blue', fontsize=14)
                ax2.tick_params(axis='y', labelcolor='blue')
                ax2.legend(loc='upper left')
            else:
                ax2.legend(loc='upper left', bbox_to_anchor = (0, 0.91))

        if appendix in ['_combined', '_kl_and_combined']:
            combined_ld_sorted = [label_distribution[client][sorting_idx] for client in clients_sorted]
            ax3 = ax1.twinx()
            ax3.plot(np.arange(len(combined_ld_sorted)) + 1, combined_ld_sorted, label=r"$SI^{comb}$",
                     color='black',
                     marker='o')
            ax3.set_ylabel(r"$SI^{comb}$", color='black', fontsize=14)
            ax3.tick_params(axis='y', labelcolor='black')
            ax3.legend(loc='upper left')

        # Adding clients and title
        ax1.set_xlabel('Clients', fontsize=14)
        ax1.set_ylabel('Datensatzgröße', fontsize=14)

        plt.tight_layout()
        if path is not None:
            plt.savefig(path + appendix + '.png', dpi=300)

# Creates label_distribution with:
# { client_id: (chi2, normal_chi2, kl, normal_kl, combined) }
#
# plots sampling-index plots
def create_data_dis_plots(client_idxs, path, args):
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
        client_label_dis = np.array([dict(label_counter).get(label, 0) for label in all_label], dtype=np.float64)

        gesamt_summe = client_label_dis.sum()
        p = client_label_dis / gesamt_summe

        q = np.ones_like(p) / len(p)

        # KL-Divergenz
        kl_div = np.sum(rel_entr(p, q))

        chi_gesamt_summe = client_label_dis.sum()
        gleichverteilung = [chi_gesamt_summe / len(client_label_dis)] * len(client_label_dis)

        # Chi-Quadrat-Test
        chi_stat, p_value = chisquare(f_obs=client_label_dis, f_exp=gleichverteilung)

        label_distribution[idx] = (chi_stat, kl_div)

    # Normalize Chi2
    chi_stats = [val[0] for _, val in label_distribution.items()]
    ldmin = np.min(chi_stats)
    ldmax = np.max(chi_stats)

    for idx, val in label_distribution.items():
        normalized_ld = 1 - ((val[0] - ldmin) / (ldmax - ldmin))
        label_distribution[idx] = (val[0], normalized_ld, val[1])

    # Normalize KL-Div
    kls = [val[2] for _, val in label_distribution.items()]
    kl_min = np.min(kls)
    kl_max = np.max(kls)

    for idx, val in label_distribution.items():
        normalized_kl = 1 - ((val[2] - kl_min) / (kl_max - kl_min))
        label_distribution[idx] = (val[0], val[1], val[2], normalized_kl)

    # Combine KL-Div and Sample Size
    daisy_data_idx = list(client_idxs.values())

    sample_sizes = np.array([len(value) for value in daisy_data_idx])
    sample_scores = sample_sizes / sample_sizes.max()
    normalized = np.array([label_distribution[i][3] for i in label_distribution.keys()])

    if args.combined_si_alpha is not None:
        alpha = float(args.combined_si_alpha)  # sample size
        beta = 1 - float(args.combined_si_alpha) # label quality
    else:
        alpha = 0.5  # Gewicht sample size
        beta = 0.5  # Gewicht label quality
    combined = alpha * sample_scores + beta * normalized

    min_combined = combined.min()
    max_combined = combined.max()
    nomalized_combined = (combined - min_combined) / (max_combined - min_combined)

    for idx, val in label_distribution.items():
        label_distribution[idx] = (val[0], val[1], val[2], val[3], nomalized_combined[idx])

    print_plot(path, label_distribution, data)

    return label_distribution
