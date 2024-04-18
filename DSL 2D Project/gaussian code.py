import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats
import numpy as np
import os
from statsmodels.tsa.stattools import acf
from scipy.stats import entropy

# Function to convert hex to decimal
def convert_hex_to_decimal(hex_value):
    try:
        return int(hex_value, 16)
    except ValueError:
        return None



# Construct the file path
file_path = os.path.join(os.path.expanduser('~'), 'Downloads', 'prng.txt')

# Read the hex numbers from the file
data = pd.read_csv(file_path, header=None, names=['Hex'])

# Convert hex to decimal and handle invalid values
data['Decimal'] = data['Hex'].apply(convert_hex_to_decimal)

# Drop rows with invalid hex values
data.dropna(subset=['Decimal'], inplace=True)

# Convert the 'Decimal' column to integer type
data['Decimal'] = data['Decimal'].astype(int)

# Plot a histogram of the decimal numbers
plt.hist(data['Decimal'], bins=50, density=True, alpha=0.6, color='g')

# Fit a normal distribution to the data and plot the PDF
mu, std = stats.norm.fit(data['Decimal'])
xmin, xmax = plt.xlim()
x = np.linspace(xmin, xmax, 100)
p = stats.norm.pdf(x, mu, std)
plt.plot(x, p, 'k', linewidth=2)
title = "Fit results: mu = %.2f,  std = %.2f" % (mu, std)
plt.title(title)

# Perform a Kolmogorov-Smirnov test for normality
ks_stat, ks_p = stats.kstest(data['Decimal'], 'norm', args=(mu, std))
print('Kolmogorov-Smirnov Test: Statistics=%.3f, p=%.3f' % (ks_stat, ks_p))

# Interpret the normality test result
alpha = 0.05
if ks_p > alpha:
    print('Sample looks Gaussian (fail to reject H0)')
else:
    print('Sample does not look Gaussian (reject H0)')

# Function to count unique numbers
unique_count = data['Decimal'].nunique()
print(f'Number of unique numbers: {unique_count}')

# Autocorrelation Test
autocorr = acf(data['Decimal'], fft=True, nlags=10)
plt.figure()
plt.bar(range(len(autocorr)), autocorr)
plt.title('Autocorrelation')
plt.show()

# Entropy Calculation
value_counts = data['Decimal'].value_counts(normalize=True)
data_entropy = entropy(value_counts)
print(f'Entropy: {data_entropy}')

plt.show()


