import pandas as pd
import numpy as np

# import matplotlib.pyplot as plt
# import seaborn as sns
import csv
import json

# %matplotlib inline

import re
import string
# from wordcloud import WordCloud
# from collections import Counter

import nltk
from nltk import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split

from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
# from scikitplot.metrics import plot_confusion_matrix, plot_roc

from sklearn.naive_bayes import BernoulliNB
from sklearn.naive_bayes import CategoricalNB
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression

from books.models import *
from features import models as features_models

import warnings
warnings.filterwarnings('ignore')  # "error", "ignore", "always", "default", "module" or "once"

nltk.download("punkt")
nltk.download("stopwords")


def parse_genre_values(genre_info):
    if genre_info == "":
        return []
    genre_dict = json.loads(genre_info)
    genres = list(genre_dict.values())
    return genres


""" def plot_genre_distribution(df):
#     plt.figure(figsize=(10,5))
#     sns.barplot(x=df['genre'].value_counts().index,y=df['genre'].value_counts())
#     plt.title('Genre Count')
#     plt.xlabel('Genres')
#     plt.ylabel('Count')"""


# The below function comes in handy to count the number of characters in a text
def char_count(text):
    charc = 0
    for char in text.split():
        charc += len(char)
    return charc


# Function to convert the combined text to lowercase.
def convertintolist(text):
    return text.split()


def clean_words(word_list):
    lower_words = [
        word.lower() for word in word_list
    ]  # Write a list comprehension to make each word in word_list lower case.
    no_punct = [
        word.translate(str.maketrans("", "", string.punctuation))
        for word in lower_words
    ]
    return " ".join(no_punct)


def remove_stopwords(text):
    words = nltk.word_tokenize(text)
    sws = stopwords.words("english")
    clean_list = [word for word in words if word not in sws]
    return " ".join(clean_list)


# Function to perform stemming on the combined text
def stem_text(text):
    stemmer = PorterStemmer()
    words = nltk.word_tokenize(text)
    stem_texts = [stemmer.stem(word) for word in words]

    return " ".join(stem_texts)

# def predict_genre(book_id, chapter_num):
# load data for training
df = pd.read_csv("/src/scripts/data.csv", index_col="index")
df = df.assign(title_len=df["title"].apply(lambda x: len(x.split())))
df = df.assign(title_char_len=df["title"].apply(char_count))
df = df.assign(summary_len=df["summary"].apply(lambda x: len(x.split())))
df = df.assign(summary_char_len=df["summary"].apply(char_count))
df["Combined_Text"] = df["title"] + " " + df["summary"]
pt_lst = []
for text in df["Combined_Text"]:
    processed_text = stem_text(remove_stopwords(clean_words(convertintolist(text))))
    pt_lst.append(processed_text)
# df = df.loc[index, 'Combined_Text'] = processed_text  # assigns processed to the cell at row index and column 'Combined_Text'
# df = df.assign(Combined_text=df['Combined_Text'].apply(lambda x:processed_text))
df["Combined_Text"] = pt_lst
print("text cleaned.")
    # Encoding the genre column
encoder = LabelEncoder()
df["genre"] = encoder.fit_transform(df["genre"].values)

# Splitting data into features(X) and targets(y)
X = df["Combined_Text"]
y = df["genre"].values
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)
tf_idf = TfidfVectorizer()
X_train = tf_idf.fit_transform(X_train).toarray()
X_test = tf_idf.transform(X_test).toarray()

lg = LogisticRegression(max_iter=1000)
print("LG made")
lg.fit(X_train, y_train)
print("LG fit")
lg_y_pred = lg.predict(X_test)

import pickle

# save the iris classification model as a pickle file
model_pkl_file = "content_tagging_model.pkl"  

with open(model_pkl_file, 'wb') as file:  
    pickle.dump(lg, file)
