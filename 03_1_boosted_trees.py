# Step 0: User Input
data_version = "21Nov23"

# Step 0.1 Config
import os
import numpy as np
import pandas as pd
import sklearn as skl
import xgboost as xgb

sys.path.append("functions")
import py_modules


# Step 1: Read in Data
df = pd.read_csv("data/output/final_model_data__"+data_version+".csv")
df.head(5)

# Step 2: Pre-treat Data
df = py_modules.clear_nas_python_2(df)