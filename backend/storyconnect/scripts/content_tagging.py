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


def predict_genre(book_id, chapter_num):
    # load data for training
    df = pd.read_csv("/src/scripts/data.csv", index_col="index")

    # create dataframe for chapters. initialized by dummy row
    # chapter_df = pd.DataFrame({
    # 'book': [0],
    # 'book_title': ['a'],
    # 'chapter_number': [0],
    # 'content': ['a']
    # })

    # load data for prediction
    predict_books = Book.objects.get(pk=book_id)
    book_id = predict_books.pk
    book_title = predict_books.title
    book_chapters = Chapter.objects.filter(book = predict_books)
    predict_chapter = Chapter.objects.get(book=predict_books, chapter_number = chapter_num)
    
    chapter_df = pd.DataFrame({'book': [book_id],
        'book_title': [book_title],
        'chapter_number': [predict_chapter.chapter_number],
        'content': [predict_chapter.content]})
    
    # for ch in book_chapters:
    #     chp = {'book': book_id,
    #     'book_title': book_title,
    #     'chapter_number': ch.chapter_number,
    #     'content': ch.content}
    #     chapter_df = chapter_df.append(chp, ignore_index = True)

    """# if book_id == -1: # filter by the user
    #     user_owner,created = User.objects.get_or_create(id=user_id)
    #     predict_books = Book.objects.filter(user=user_owner)

    #     for p_book in predict_books:
    #         book_id = p_book.pk
    #         book_title = p_book.title
    #         book_chapters = Chapter.objects.filter(book = p_book)

    #         for chapter in book_chapters:
    #             ch = {'book': book_id,
    #             'book_title': book_title,
    #             'chapter_number': chapter.chapter_number,
    #             'content': chapter.content}
    #             chapter_df = chapter_df.append(ch, ignore_index=True)"""

    # drop the dummy row
    # chapter_df = chapter_df.iloc[1:, :]

    # pre-processing data used for testing when initially
    """data = []
    # with open('/src/features/booksummaries.txt', 'r') as f:
    #     reader = csv.reader(f, dialect='excel-tab')
    #     for row in reader:
    #         data.append(row)

    # # convert data to pandas dataframe
    # books = pd.DataFrame.from_records(data, columns=['book_id', 'freebase_id', 'book_title', 'author', 'publication_date', 'genre', 'summary'])
    
    # books['genre'] = books['genre'].apply(parse_genre_values)
    # books = books.drop(columns = ['freebase_id', 'author', 'publication_date','book_id'])

    # # check for missing values and duplicates
    # books['genre'] = books['genre'].apply(lambda x: np.NaN if len(x) == 0 else x)

    # print(books.isnull().sum().sort_values(ascending = False))
    # print(df.isnull().sum().sort_values(ascending = False))

    # collect the ones that doesn't have genres
    # null_genre = pd.isnull(books["genre"])
    # null_genre = books[null_genre]"""

    # Generating the column title_len
    df = df.assign(title_len=df["title"].apply(lambda x: len(x.split())))
    chapter_df = chapter_df.assign(
        book_title_len=chapter_df["book_title"].apply(lambda x: len(x.split()))
    )

    # Generating the column title_char_len
    df = df.assign(title_char_len=df["title"].apply(char_count))
    chapter_df = chapter_df.assign(
        title_char_len=chapter_df["book_title"].apply(char_count)
    )

    # Generating the column summary_len and summary_char_len
    df = df.assign(summary_len=df["summary"].apply(lambda x: len(x.split())))
    df = df.assign(summary_char_len=df["summary"].apply(char_count))
    chapter_df = chapter_df.assign(
        summary_len=chapter_df["content"].apply(lambda x: len(x.split()))
    )
    chapter_df = chapter_df.assign(
        summary_char_len=chapter_df["content"].apply(char_count)
    )

    # grouping books by genres based on title length and title character's length
    # df.groupby('genre')[['title_len','title_char_len']].describe().transpose()

    # Combining the title and summary column for further text preprocessing
    df["Combined_Text"] = df["title"] + " " + df["summary"]
    chapter_df["Combined_Text"] = chapter_df["book_title"] + " " + chapter_df["content"]

    #Finally we run the above defined funtions on the column Combined_Text
    """# df['Combined_Text']=df['Combined_Text'].apply(lowercase)
    # df['Combined_Text']=df['Combined_Text'].apply(removepunc)
    # df['Combined_Text']=df['Combined_Text'].apply(remove_sw)
    # df['Combined_Text']=df['Combined_Text'].apply(stem_text)"""

    # df.head()
    pt_lst = []
    for text in df["Combined_Text"]:
        processed_text = stem_text(remove_stopwords(clean_words(convertintolist(text))))
        pt_lst.append(processed_text)
    # df = df.loc[index, 'Combined_Text'] = processed_text  # assigns processed to the cell at row index and column 'Combined_Text'
    # df = df.assign(Combined_text=df['Combined_Text'].apply(lambda x:processed_text))
    df["Combined_Text"] = pt_lst
    print("text data cleaned.")
    # remove the genre column as it is the y label column
    # null_genre = null_genre.drop(columns=['genre'])

    pt_lst_test = []
    for text in chapter_df["Combined_Text"]:
        processed_text = stem_text(remove_stopwords(clean_words(convertintolist(text))))
        pt_lst_test.append(processed_text)
    chapter_df["Combined_Text"] = pt_lst_test
    print("text content cleaned.")

    # Encoding the genre column
    encoder = LabelEncoder()
    df["genre"] = encoder.fit_transform(df["genre"].values)

    # Splitting data into features(X) and targets(y)
    X = df["Combined_Text"]
    y = df["genre"].values
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    chapter_df_test = chapter_df["Combined_Text"]

    """data needs to be converted into a numerical format where each word is represented by a matrix.
       Term Frequency (TF) = (Frequency of a term in the document)/(Total number of terms in documents)
       Inverse Document Frequency(IDF) = log( (total number of documents)/(number of documents with term t))"""

    tf_idf = TfidfVectorizer()
    X_train = tf_idf.fit_transform(X_train).toarray()
    X_test = tf_idf.transform(X_test).toarray()
    chapter_df_test = tf_idf.transform(chapter_df_test).toarray()
    print("TF-IDF completed")

    """ after testing several classification models, it is proven that logistic regression has the best fit for the best accuracy."""
    lg = LogisticRegression(max_iter=1000)
    print("LG made.")
    lg.fit(X_train, y_train)
    print("LG fit")
    # lg_y_pred = lg.predict(X_test)
    lg_y_pred_test = lg.predict(chapter_df_test)
    print("LG predicted.")
    # lg_y_prob = lg.predict_proba(X_test)
    # accuracy = round(accuracy_score(y_test, lg_y_pred), 3)
    # precision = round(precision_score(y_test, lg_y_pred, average="weighted"), 3)
    # recall = round(recall_score(y_test, lg_y_pred, average="weighted"), 3)

    # Converting back from label encoded form to labels
    # lg_y_pred = encoder.inverse_transform(lg_y_pred)
    lg_y_pred_test = encoder.inverse_transform(lg_y_pred_test)

    # plot for confusion matrix
    """# fig, ax = plt.subplots(1, 2, figsize = (25,  8))
    # ax1 = plot_confusion_matrix(y_test, lg_y_pred, ax= ax[0], cmap= 'YlGnBu')
    # ax2 = plot_roc(y_test, lg_y_prob, ax= ax[1], plot_macro= False, plot_micro= False, cmap= 'summer')

    # test_pred.savetxt('decision_tree_pred.csv',test_pred, fmt = '%d', delimiter=",")
    # test_pred.tofile('/content/drive/MyDrive/Colab Notebooks/dec_tree_pred.csv', sep = ',')
    # with open('/content/drive/MyDrive/Fall 2023/decision_tree_pred.csv', 'w') as f:
    #     mywriter = csv.writer(f, delimiter=',')
    #     mywriter.writerow(['ID','Prediction'])
    #     mywriter.writerows(enumerate(lg_y_pred_test,1))"""

    # chapter_df = chapter_df.join(lg_y_pred_test)
    lg_y_pred_test = pd.DataFrame(lg_y_pred_test, columns=["genre"])
    chapter_df = pd.concat([chapter_df, lg_y_pred_test], axis=1)

    return chapter_df

def contenttag_test():
    me, created = User.objects.get_or_create(pk=11)
    
    all_user_books = Book.objects.filter(user=me)

    for book in all_user_books:
        # if book.pk in [79,81,85,80]:
        if book.pk == 79:
            print(book)
            book_genretag,created = features_models.GenreTagging.objects.get_or_create(book=book)
            book_genre, created = Book.objects.get_or_create(pk=book.pk)
            chapters_genres = []
            for chap in book.get_chapters():
                chapter_genre, created = features_models.ChapterTagging.objects.get_or_create(chapter = chap)
                updated_chapter_len = len(chap.content)
                # if updated_chapter_len >= 2*chapter_genre.last_chapter_len and updated_chapter_len>=1000 and chap.chapter_number != 1:
                chapter_df = predict_genre(book_id=book.pk, chapter_num=chap.chapter_number)
                generated_genre = list(chapter_df['genre'].values)
                chapter_genre.genre = generated_genre
                chapters_genres.append(generated_genre)
                chapter_genre.last_chapter_len = updated_chapter_len
                tmp_lst = chapter_genre.genre
                # for idx,i in enumerate(chapters_genres):
                #     chapters_genres[idx] = list(i)
                    # print(list(i))
                # chapters_genres = chapters_genres + tmp_lst
                print(chapter_genre.genre)
                if any(isinstance(i, list) for i in chapters_genres) == True:
                    chapters_genres = list(np.concatenate(chapters_genres).flat)
                    # chapters_genres = np.sum(chapters_genres,[])
                # chapters_genres = set(chapters_genres)
                # chapters_genres = list(chapters_genres)
                chapter_genre.genre = chapters_genres
                print(chap.chapter_number,":", chapter_genre.genre)
                chapter_genre.save()

        # genres_of_the_book_from_book_model = book_genre.tags
        # genres_of_the_book_from_book_model = book_models.Book._meta.get_field('tags').value_from_object(book_genre)
        
            # check if the genres in both models are the same
            genre_from_tag = book_genretag.genre
            genre_from_book = book_genre.tags
            genre_combined = genre_from_book+genre_from_tag             

            if genre_from_book != genre_from_tag or len(genre_from_tag) == 0 or len(genre_from_book) == 0:
                # book_genre_combined = list(set(genre_combined))
                book_genre_combined = set(genre_combined)
            else:
                book_genre_combined = genre_from_book

            print("genre_from_tag: ", genre_from_tag)
            print("genre_from_book: ", genre_from_book)
            print("genre_combined: ", genre_combined)
            print("book_genre_combined: ", book_genre_combined)
            print("genre_combined type: ", type(book_genre_combined))
            print("chapters_genres: ", chapters_genres)
            book_genre_combined = list(book_genre_combined)
            # collect the added genres
            added_genres = []
            print("added_genre type: ", type(added_genres))
            for genre in chapters_genres:
                print("genre",genre)
                if genre not in book_genre_combined:
                    added_genres.append(genre)
            if any(isinstance(i, list) for i in added_genres):
                    added_genres = list(np.concatenate(added_genres).flat)
            print("added_genre as list: ", added_genres)
            added_genres = set(added_genres)
            print("added_genre as set: ", added_genres)
            added_genres = list(added_genres)
            print("added_genre as list: ", added_genres)

            # book_genre_combined = book_genre_combined.union(added_genres)
            book_genre_combined = book_genre_combined+added_genres
            # book_genre_combined = list(book_genre_combined)
            print("book_genre_combined: ", book_genre_combined)

            # update the book genre with the additional genres
            features_models.GenreTagging.objects.filter(book=book).update(genre=book_genre_combined)
            Book.objects.filter(pk=book_genre.pk).update(tags=book_genre_combined)
            print("finished.")  

def run():
    # chapter_df = predict_genre(book_id=84, chapter_num=1)
    # chapter_df.to_csv('/src/scripts/chapter_genres_df.csv',index=False)
    contenttag_test()
    # logger.info('content tagging finished.')
    """genre_from_tag:  []
genre_from_book:  ["['Historical fiction'", "'Biographical fiction'", "'Love stories'", "'France  Fiction'", "'Manwoman relationships  Fiction'", "'French fiction  Translations into English'", "'Letters  Fiction'", "'Romance fiction']"]
genre_combined:  ["['Historical fiction'", "'Biographical fiction'", "'Love stories'", "'France  Fiction'", "'Manwoman relationships  Fiction'", "'French fiction  Translations into English'", "'Letters  Fiction'", "'Romance fiction']"]
book_genre_combined:  ["'Manwoman relationships  Fiction'", <ChapterTagging: ChapterTagging object (7)>, <ChapterTagging: ChapterTagging object (8)>, <ChapterTagging: ChapterTagging object (9)>, <ChapterTagging: ChapterTagging object (10)>, "['Historical fiction'", "'Romance fiction']", "'France  Fiction'", "'Love stories'", "'Biographical fiction'", "'Letters  Fiction'", "'French fiction  Translations into English'"]
finished."""

# 'Pompeii (Extinct city)  Fiction'],['Historical fiction'',ChapterTagging object (1),ChapterTagging object (1)'