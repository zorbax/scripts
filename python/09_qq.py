#!/usr/bin/env

from numpy.random import seed
from numpy.random import randn

import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt


def plot(data, cdf=stats.norm.cdf):
    plt.figure()
    plt.plot(np.cumsum(1./len(data) * np.ones(data.shape)),
             cdf(np.sort(data)), 'bx', marker='o')
    plt.plot((0, 1), (0, 1), 'r-')

    plt.ylim(0, 1)
    plt.xlim(0, 1)
    plt.xlabel('empirical percentiles')
    plt.ylabel('fit percentiles')
    plt.show()


seed(1)

data = randn(100)

plot(data)
