# Step 0: User Input
data_version = "21Nov23"
seed = 123

# Step 0.1 Config
import sys
import os
import numpy as np
import pandas as pd
import sklearn as skl
import xgboost as xgb

sys.path.append("functions/py")
import py_modules


# Step 1: Read in Data
df = pd.read_csv("data/output/final_model_data__"+data_version+".csv")

cols_to_remove = ['Unnamed: 0','team','date','tournament','confederation']
df=df.drop(columns=cols_to_remove)

df.head(5)

# Step 2: Pre-treat Data, partition
df = py_modules.clear_nas_python(df)
X,y = df.drop('result',axis=1),df.result
X_train, X_test, y_train, y_test = skl.train_test_split(X, y, test_size=0.3, random_state=seed)
