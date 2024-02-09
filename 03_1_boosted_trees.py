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

# Step 2: Pre-treat Data, multifactor hot-encode
df = py_modules.clear_nas_python(df)

he_map = {'win': 0,
             'loss': 1, 
             'tie': 2}
df['result'] = df['result'].map(he_map) 

# Step 3: Partition
X,y = df.drop('result',axis=1),df.result

X_train, X_test, y_train, y_test = skl.model_selection.train_test_split(X, y, test_size=0.3, random_state=seed)

print("The shape of X_train is      ", X_train.shape)
print("The shape of X_test is       ",X_test.shape)
print("The shape of y_train is      ",y_train.shape)
print("The shape of y_test is       ",y_test.shape)


# Step 4: Train Model
# Create the default XGBoost model object
xgb_model = xgb.XGBClassifier(objective='multi:softmax', 
                            num_class=3, 
                            missing=1, 
                            early_stopping_rounds=10, 
                            eval_metric=['merror','mlogloss'], 
                            seed=seed)

# Define the hyperparameter grid
param_grid = {
    'max_depth': [5],
    'learning_rate': [0.01],
    'subsample': [0.7]
}

# Create the GridSearchCV object
grid_search = skl.model_selection.GridSearchCV(xgb_model, param_grid, cv=5, scoring='accuracy')

# Fit the GridSearchCV object to the training data
grid_search.fit(X_train, y_train)

# Print the best set of hyperparameters and the corresponding score
print("Best set of hyperparameters: ", grid_search.best_params_)
print("Best score: ", grid_search.best_score_)
