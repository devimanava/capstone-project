# capstone-project

## Objective
We see multiple branded food categories that have different energy and nutrient profiles - some of these branded food items also highlight multiple benefits (examples include low sugar, high fiber etc.) - the presence of so many data points can make it difficult for consumers to make an informed choice in a short time.

Machine learning concepts can be applied on a dataset that contains nutritional information and additional supporting factors for a large variety of branded food items available in the market today to understand which nutrients determine the overall calorie value for a particular food item and also predict the energy profile based on the nutrient composition. 

The initial objective of this repo is to extract the branded food data provied by USDA FDC website, do necessary transformations using EDA techniques and build a baseline linear regression model. Subsequent iterations will look at alternate machine learning models and additional techniques to enhance predicting accuracy like hyperparameter tuning. 

## Overview of the Approach Chosen
In order to build a baseline machine learning model, this document largely follows the CRISP-DM framework. The below phases would be executed:

Phase 0: Data Preparation: This phase involves reviewing the individual CSV files downloaded from USDA's FDC website and consolidating them into a single CSV file for this project

Phase 1: Data Understanding: This phase imports the CSV file prepared above and does an initial exploration for understanding the columns and discovering patterns that need to be addressed

Phase 2: Data Cleaning and Preparation: This phase leverages multiple exploratory data analysis (EDA) techniques to make necessary changes to the dataset to make it more usable for building machine learning models. 

Phase 3: Building a Baseline Model: The prepared data would then be used for building an initial linear regression model - the model performance would then be used as a baseline for the next iteration of this notebook.

## Development Details
- The Jupyter notebook capstone_V1.ipynb has the code and execution results for each phase listed above
- The file data_prep_bq.sql is a BigQuery query template that reads the different CSV files downloaded from the USDA FDC website for branded data and conducts necessary joins and pivots to get the data in the required format for this project.
- The file final_result_v2_csv.zip contains the file final_result_v2.csv, which is the output of the BigQuery execution and is used as the starting point in the Jupyter notebook
- The file 'Capstone - Food Category Mapping-Sheet1.csv' is an offline manual exercise to clean the number of branded food categories. Additional context can be viewed in the Jupyter notebook


## Findings from the Exercise
Linear regression results had high coefficient of determination values for both training and test data, indicating the linear regression model is able to do a good job of predicting trends on energy values based on individual nutrient columns. It also had a low MAE of ~12, indicating the model does a good job of predicting the energy values for the most part.

The MSE of 670+ and 690+ on training and test data is an interesting observation and shows that the model has the potential to throw a large error due the presence of outliers in the data. This is expected since the data we have is right skewed.

Hence there is an opportunity to evaluate other models that can handle skewed data better.



