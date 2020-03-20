## Navigation

### 1. frankel_rose > literature_replication2.Rmd

#### Goals
1. Replicate Frankel and Rose (1996) which is a simple probit model but choose probability cutoff to maximise the area under the ROC curve.
2. Show off-the-shelf machine learning on the same dataset: random forest, KNN and SVN

#### Summary of findings

1. Probit models often do not need tuning. But in the context of imbalanced dataset, we can make a probit model much more sensitive by setting the threshold of classifying a crisis observation low. For instance, as opposed to using a 50% cut-off (i.e. when predicted probability exceeds 0.5, classify the obs as crisis), you can use other cut-off values. In this script, I showed that you can make probit sensitive whilst keeping false alarm rate low by choosing a cut-off that maximises the area under the ROC curve.

2. After making this change, the out-of-sample performance between probit and machine learning algos shrinks.

3. Having said that, in this experiment, probit is very noisy and in that regard random forest does much better. Mind you without “tuning” the probit model, its performance is nowhere close to its ML counterparts. Still in terms of area under the ROC curve, KNN and Random Forest still win.

3. We may want to try neural networks as they are rare in the literature so far and they have some attractive features - see below description.

### 2. toy_autoencoder.ipynb

Here I used another dataset from JST which has been used by quite a few papers.

#### Goals

1. The main difficulty of the prediction task comes from the imbalance of classes - we have more non-crisis obs than crisis. And often this means we have to oversample the minority class to achieve reasonable accuracy.

2. Instead of messing with the data, autoencoders embrace this imbalance: The idea is simple, just train the model using the non-crisis data, then you will have a good idea of how things play out where there's no crisis. Then reconstruct the whole dataset using the trained model. What you should see is that reconstruction error is low where there is indeed no crisis, and shoots up when there is one. This way you do not have to oversample the dataset to solve the class imbalance.

3. An added benefit is that in the literature, this type of classification task ignores the time dimension. But we can always pair autoencoders with a LSTM layer which will then allow us to make use of the time dimension - ***something not many papers have done.***

#### Summary of findings

1. The toy autoencoder isn't thriving but not bad at all given how lightly tuned it is.

### Tasks

1. Tune the neural network more carefully
2. Add in LSTM
3. Make the model intepretable [link to paper](https://papers.nips.cc/paper/7062-a-unified-approach-to-interpreting-model-predictions.pdf)

## Dependencies
See requirements.txt
