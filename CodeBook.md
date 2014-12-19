# CodeBook for Getting and Cleaning Data MOOC

The code is quite clear and has many comments on it.
This document will just describe some implementation aspects.

1. data: The data frame used to store the main information (subject, activity, features)

2. feature: contains the name of the features in the dataset. And from there the following variables are calculated:

* idxs: contains the positions of the features with mean and std
* txts: contains the descriptive text of the same features

3. activities: the name of the activities in the dataset

4. agg: contains the result of the aggregated means by subject+activity
