# International Football Prediction Model

The deployed model can be viewed in a web application here (UNDER CONSTRUCTION).

## Repository Contents:

Folders:
- data (not tracked)
- functions
- models (not tracked)
- docs


Scripts/Notebooks:
- 01: data pipelines
- 02: data validation/quality checks + univariate/bivariate testing
- 03: model builds
- 04: PiT data pipelines
- 05: model deployment



## Data Sources:

### International Rankings through Time
- https://www.kaggle.com/cashncarry/fifaworldranking

### International Football Match Results
- https://www.kaggle.com/martj42/international-football-results-from-1872-to-2017


## Methodology:

### Data preparation:
- a trailing 15 year window of data is used

Too many rows in data increases the training time of complexd models - while not necessarily adding any predictive power.
More recent datapoints more accurately generalize to the current status of commercial, professional football
- countries that no longer exist are discarded

This includes when countries 'merge' or 'demerge' (i.e. Yugoslavia). This isnt as much of a problem taking recent 15 years of data, as opposed to taking 20th Century observations.

## Performance:

Model performance dashboard can be viewed [here](https://ilchef.github.io/international_football_prediction_model/).
