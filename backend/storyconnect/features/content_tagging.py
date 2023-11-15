import pandas as pd
import numpy as np
import csv
import json

# %matplotlib inline

import re
import string

import nltk
nltk.download('punkt')
nltk.download('stopwords')
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

def parse_genre_values(genre_info):
    if genre_info == '':
        return []
    genre_dict = json.loads(genre_info)
    genres = list(genre_dict.values())
    return genres

# The below function comes in handy to count the number of characters in a text
def char_count(text):
    charc=0
    for char in text.split():
        charc +=len(char)
    return charc

# Function to convert the combined text to lowercase.
def convertintolist(text):
    return text.split()

def clean_words(word_list):
    lower_words = [word.lower() for word in word_list] # Write a list comprehension to make each word in word_list lower case.
    no_punct = [word.translate(str.maketrans('', '', string.punctuation)) for word in lower_words]
    return ' '.join(no_punct)

def remove_stopwords(text):
    words=nltk.word_tokenize(text)
    sws=stopwords.words('english')
    clean_list = [word for word in words if word not in sws]
    return ' '.join(clean_list)

# Function to perform stemming on the combined text
def stem_text(text):
    stemmer=PorterStemmer()
    words=nltk.word_tokenize(text)
    stem_texts = [stemmer.stem(word) for word in words]

    return ' '.join(stem_texts)
    
def predict_genre(book_id, chapter_num):
    # load data for training
    df=pd.read_csv('/src/scripts/data.csv',index_col='index')

    # load data for prediction
    predict_books =  Book.objects.get(pk = book_id)
    book_id = predict_books.pk
    book_title = predict_books.title
    book_chapters = Chapter.objects.filter(book = predict_books)
    predict_chapter = Chapter.objects.get(book=predict_books, chapter_number = chapter_num)

    chapter_df = pd.DataFrame(
    {'book': [book_id],
    'book_title': [book_title],
    'chapter_number': [predict_chapter.chapter_number],
    'content': [predict_chapter.content]})

    #Generating the column title_len
    df = df.assign(title_len = df['title'].apply(lambda x:len(x.split())))
    chapter_df = chapter_df.assign(book_title_len = chapter_df['book_title'].apply(lambda x: len(x.split())))
    
    #Generating the column title_char_len
    df = df.assign(title_char_len = df['title'].apply(char_count))
    chapter_df = chapter_df.assign(title_char_len = chapter_df['book_title'].apply(char_count))

    #Generating the column summary_len and summary_char_len
    df = df.assign(summary_len=df['summary'].apply(lambda x:len(x.split())))
    df = df.assign(summary_char_len=df['summary'].apply(char_count))
    chapter_df = chapter_df.assign(summary_len = chapter_df['content'].apply(lambda x: len(x.split())))
    chapter_df = chapter_df.assign(summary_char_len = chapter_df['content'].apply(char_count))

    #Combining the title and summary column for further text preprocessing
    df['Combined_Text']=df['title'] + ' ' + df['summary']
    chapter_df['Combined_Text']=chapter_df['book_title'] + ' ' + chapter_df['content']

    # df.head()
    pt_lst = []
    for text in df['Combined_Text']:
        processed_text = stem_text(remove_stopwords(clean_words(convertintolist(text))))
        pt_lst.append(processed_text)
    
    df['Combined_Text'] = pt_lst

    pt_lst_test = []
    for text in chapter_df['Combined_Text']:
        processed_text = stem_text(remove_stopwords(clean_words(convertintolist(text))))
        pt_lst_test.append(processed_text)
    chapter_df['Combined_Text'] = pt_lst_test

    #Encoding the genre column
    encoder=LabelEncoder()
    df['genre']=encoder.fit_transform(df['genre'].values)

    # Splitting data into features(X) and targets(y)
    X=df['Combined_Text']
    y=df['genre'].values
    X_train,X_test,y_train,y_test=train_test_split(X,y,test_size= 0.3, random_state= 42,stratify=y)

    chapter_df_test = chapter_df['Combined_Text']

    """data needs to be converted into a numerical format where each word is represented by a matrix.
       Term Frequency (TF) = (Frequency of a term in the document)/(Total number of terms in documents)
       Inverse Document Frequency(IDF) = log( (total number of documents)/(number of documents with term t))"""

    tf_idf = TfidfVectorizer()
    X_train=tf_idf.fit_transform(X_train).toarray()
    X_test=tf_idf.transform(X_test).toarray()
    chapter_df_test = tf_idf.transform(chapter_df_test).toarray()

    """ after testing several classification models, it is proven that logistic regression has the best fit for the best accuracy."""
    lg=LogisticRegression()
    lg.fit(X_train, y_train)
    lg_y_pred = lg.predict(X_test)
    lg_y_pred_test = lg.predict(chapter_df_test)
    lg_y_prob= lg.predict_proba(X_test)
    accuracy=round(accuracy_score(y_test,lg_y_pred),3)
    precision=round(precision_score(y_test,lg_y_pred,average='weighted'),3)
    recall=round(recall_score(y_test,lg_y_pred,average='weighted'),3)
    
    # Converting back from label encoded form to labels
    lg_y_pred_test = encoder.inverse_transform(lg_y_pred_test)

    # chapter_df = chapter_df.join(lg_y_pred_test)
    lg_y_pred_test = pd.DataFrame(lg_y_pred_test, columns=['genre'])
    chapter_df = pd.concat([chapter_df, lg_y_pred_test], axis=1)

    return chapter_df