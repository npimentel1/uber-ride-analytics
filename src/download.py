import kagglehub
import pandas as pd
import os

# Download dataset from Kaggle
path = kagglehub.dataset_download("yashdevladdha/uber-ride-analytics-dashboard")

# Found CSV file
file = [file for file in os.listdir(path) if file.endswith('.csv')][0]
file_path = os.path.join(path, file)
df = pd.read_csv(file_path)

# Save to data directory (um nível acima de src/)
base_dir = os.path.dirname(os.path.dirname(__file__))  # sobe uma pasta
output_path = os.path.join(base_dir, 'data', 'base_uber.csv')
os.makedirs(os.path.dirname(output_path), exist_ok=True)

df.to_csv(output_path, index=False, sep=",", encoding='utf-8-sig')