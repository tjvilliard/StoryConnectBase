import pandas as pd
import joblib
import re
import string
import numpy as np
import nltk
from nltk import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer

from books.models import *
from features import models as features_models

import warnings
warnings.filterwarnings('ignore')  # "error", "ignore", "always", "default", "module" or "once"

nltk.download('punkt')
nltk.download('stopwords')

# title = input("Enter title: ")
# text = input("Enter text: ")

def predict_genre(book_id,chapter_num):
    # load data for prediction
    predict_books = Book.objects.get(pk=book_id)
    book_id = predict_books.pk
    book_title = predict_books.title
    book_chapters = Chapter.objects.filter(book = predict_books)
    predict_chapter = Chapter.objects.get(book=predict_books, chapter_number = chapter_num)
    
    df_data = pd.DataFrame({'book': [book_id],
        'title': [book_title],
        'chapter_number': [predict_chapter.chapter_number],
        'summary': [predict_chapter.content]})
    # df_data = pd.DataFrame({'title': [title], 'summary':[text]})
    # df_data.head()

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

    #Combining the title and summary column for further text preprocessing
    df_data['Combined_Text']=df_data['title'] + ' ' + df_data['summary']
    df_data.head()

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

    #Finally we run the above defined funtions on the column Combined_Text
    pt_lst = []
    for text in df_data['Combined_Text']:
        processed_text = stem_text(remove_stopwords(clean_words(convertintolist(text))))
        pt_lst.append(processed_text)

    df_data['Combined_Text'] = pt_lst
    df_data.head()

    loaded_encoder=joblib.load('scripts/models/encoder_model.joblib')
    loaded_tfidf=joblib.load('scripts/models/tf-idf.joblib')
    loaded_lg=joblib.load('scripts/models/lg_model.joblib')

    xtest=loaded_tfidf.transform(df_data['Combined_Text']).toarray()

    predicted_genre = loaded_lg.predict(xtest)

    return predicted_genre


def contenttag_test():
    me, created = User.objects.get_or_create(pk=11)
    
    all_user_books = Book.objects.filter(user=me)

    for book in all_user_books:
        # if book.pk in [79,81,85,80]:
        if book.pk == 85:
            print(book)
            book_genretag,created = features_models.GenreTagging.objects.get_or_create(book=book)
            book_genre, created = Book.objects.get_or_create(pk=book.pk)
            chapters_genres = []
            for chap in book.get_chapters():
                chapter_genre, created = features_models.ChapterTagging.objects.get_or_create(chapter = chap)
                updated_chapter_len = len(chap.content)
                # if updated_chapter_len >= 2*chapter_genre.last_chapter_len and updated_chapter_len>=1000 and chap.chapter_number != 1:
                chapter_df = predict_genre(book_id=book.pk, chapter_num=chap.chapter_number)
                # generated_genre = list(chapter_df['genre'].values)
                generated_genre = list(chapter_df)
                chapter_genre.genre = generated_genre
                chapters_genres.append(generated_genre)
                chapter_genre.last_chapter_len = updated_chapter_len
                tmp_lst = chapter_genre.genre
                # for idx,i in enumerate(chapters_genres):
                #     chapters_genres[idx] = list(i)
                    # print(list(i))
                # chapters_genres = chapters_genres + tmp_lst
                # print("chapters_genres: ", chapters_genres)
                # print(chapter_genre.genre)
                # if any(isinstance(i, list) for i in chapters_genres) == True:
                    # chapters_genres = np.sum(chapters_genres,[])
                # chapters_genres = set(chapters_genres)
                # chapters_genres = list(chapters_genres)
                chapter_genre.genre = chapters_genres
                # print(chap.chapter_number,":", chapter_genre.genre)
                chapter_genre.save()
            if isinstance(chapters_genres[-1], list) == True:
                # chapters_genres = list(np.concatenate(chapters_genres).flat)
                chapters_genres = [element for nestedlist in chapters_genres for element in nestedlist]
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

            # print("genre_from_tag: ", genre_from_tag)
            # print("genre_from_book: ", genre_from_book)
            # print("genre_combined: ", genre_combined)
            # print("book_genre_combined: ", book_genre_combined)
            # print("genre_combined type: ", type(book_genre_combined))
            # print("chapters_genres: ", chapters_genres)
            book_genre_combined = list(book_genre_combined)
            # collect the added genres
            added_genres = []
            # print("added_genre type: ", type(added_genres))
            for genre in chapters_genres:
                # print("genre",genre)
                if genre not in book_genre_combined:
                    added_genres.append(genre)
            if any(isinstance(i, list) for i in added_genres):
                    added_genres = list(np.concatenate(added_genres).flat)
            # print("added_genre as list: ", added_genres)
            added_genres = set(added_genres)
            # print("added_genre as set: ", added_genres)
            added_genres = list(added_genres)
            # print("added_genre as list: ", added_genres)

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

# 'Pompeii (Extinct city)  Fiction'],['Historical fiction'',ChapterTagging object (1),ChapterTagging object (1)'