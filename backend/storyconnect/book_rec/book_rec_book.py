import numpy as np
import pandas as pd

import warnings
warnings.filterwarnings('ignore')

from sklearn.metrics.pairwise import cosine_similarity
from sklearn.neighbors import NearestNeighbors
from scipy.sparse import csr_matrix

from models import *
from books.models import *
from comment.models import *

"""# Recommendation Without Algorithm"""
def recommend(book_pivot, similarity_score, bookname):
    recommendations = []
    index = np.where(book_pivot.index == bookname)[0][0]
    similar_items = sorted(list(enumerate(similarity_score[index])),key = lambda x :x[1], reverse = True)[1:11]

    for i in similar_items:
        recommendations.append(book_pivot.index[i[0]])
    
    return recommendations

"""# With Machine Learning"""
def rec_with_ML(book_pivot, book_id):
    book_title = Book.objects.get(pk=book_id).title
    x = np.where(book_pivot.index == book_title)[0][0]

    book_sparse = csr_matrix(book_pivot)
    model = NearestNeighbors(algorithm= 'brute')
    model.fit(book_sparse)
    model.get_params()  
    distances , suggestions = model.kneighbors(book_pivot.iloc[x,:].values.reshape(1,-1), n_neighbors = 10)
    
    recommendations = []
    for i in suggestions:
        recommendations.append(book_pivot.index[i])

    return recommendations
    # x = np.where(book_pivot.index == book_name)[0][0]
    # distance , suggestion = model.kneighbors(book_pivot.iloc[x,:].values.reshape(1,-1), n_neighbors = 6)
    # for i in suggestion:
    #     print(book_pivot.index[i])

def ML_with_title(book_id, book_pivot, model):
    book_title = Book.objects.get(pk=book_id).title

    recommendations=[]
    x = np.where(book_pivot.index == book_title)[0][0]
    distance , suggestion = model.kneighbors(book_pivot.iloc[x,:].values.reshape(1,-1), n_neighbors = 6)
    for i in range(len(suggestion)):
        if i == 0:
            print(' Suggestion for ',book_title,' are :')

        recommendations.append(book_pivot.index[suggestion[i]])
    return recommendations

def create_book_dataframe():
    all_books = Book.objects.all()
    
    # dummy df
    df_books_test = pd.DataFrame(
    {'book_id': [79],
    'book_title': ["The Hidden Masterpiece"]})

    for each_book in all_books:
        book_entry = {
            'book_id': each_book.pk,
            'book_title': each_book.title
        }
        df_books_test.append(book_entry, ignore_index=True)

    df_books_test = df_books_test.iloc[1:, :]

    return df_books_test

def create_ratings_dataframe():
    all_users = User.objects.all()
    
    # dummy df
    df_ratings_test = pd.DataFrame(
    {'user_id': [3],
    'book_id': [79],
    'rating': [3]})
    
    for each_user in all_users:
        the_user_ratings = WriterFeedback.objects.filter(user=each_user)

        for user_rate in the_user_ratings:
            user_rating_entry = {
                'user_id': each_user.pk,
                'book_id': user_rate.selection.chapter.book.pk,
                'rating': user_rate.sentiment
            }
            df_ratings_test.append(user_rating_entry, ignore_index = True)

    return df_ratings_test

def all_books_recommend(book_pivot, similarity_score):
    all_books = Book.objects.all()

    book_based_rec = pd.DataFrame({
        'book_id' : [79],
        'recommendations' : [85]
    })
    for each_book in all_books:
        user_rec = {
            'book_title' : each_book.title,
            'recommendations' : recommend(book_pivot, similarity_score, each_book.title)
        }
        book_based_rec.append(user_rec)
    book_based_rec = book_based_rec.iloc[1:, :]
    return book_based_rec

def book_rec_book_based():
    df_books = pd.read_csv('backend/storyconnect/book_rec/general_book_rec_dataset/general_books.csv', sep = ',',on_bad_lines= 'skip', encoding ='latin-1')
    df_users = pd.read_csv('/content/drive/MyDrive/Fall2023/CS4500/general_book_rec_dataset/general_users.csv',sep = ',',on_bad_lines = 'skip',encoding ='latin-1')
    df_ratings = pd.read_csv('/content/drive/MyDrive/Fall2023/CS4500/general_book_rec_dataset/general_ratings.csv', sep = ',', on_bad_lines = 'skip', encoding = 'latin-1')

    # formatting and renaming columns
    df_books = df_books.iloc[:,:-3]
    df_books.rename(columns = {'ISBN':'book_id',
                            'Book-Title':'title',
                            'Book-Author':'author',
                            'Year-Of-Publication':'year',
                            'Publisher':'publisher'}, inplace = True)

    df_users.rename(columns = {'User-ID':'user_id',
                            'Location':'location',
                            'Age':'age'}, inplace = True)

    df_ratings.rename(columns = {'User-ID':'user_id',
                              'ISBN': 'book_id',
                              'Book-Rating':'rating'},inplace = True)

    # load database
    df_books_test = create_book_dataframe()
    df_ratings_test = create_ratings_dataframe()

    # dataframe formatting from data
    df_books = df_books.drop(columns = ['author', 'year', 'publisher'])
    df_books["book_id"] = pd.to_numeric(df_books["book_id"], downcast='signed')

    # filter out the ratings
    rat = df_ratings.user_id.value_counts()>200
    rat = rat[rat].index
    df_ratings = df_ratings[df_ratings.user_id.isin(rat)]

    # merge books with ratings grouped by title
    books_ratings = df_ratings.merge(df_books,on = 'book_id')
    books_rating = books_ratings.groupby('book_id')['rating'].count().reset_index() #.rename(columns = {'rating':'no._of_rating'},inplace= True)
    books_ratings_test = df_ratings_test.merge(df_books_test,on = 'book_id')
    books_rating_test = books_ratings_test.groupby('book_id')['rating'].count().reset_index() #.rename(columns = {'rating':'no._of_rating'},inplace= True)

    # rating count and merge again with previous book ratings
    books_rating.rename(columns = {'rating':'no._of_total_ratings'},inplace = True)
    final_rating = books_ratings.merge(books_rating,on = 'title')
    books_rating_test.rename(columns = {'rating':'no._of_total_ratings'},inplace = True)
    final_rating_test = books_ratings_test.merge(books_rating_test,on = 'title')

    # This gives us books which are rated by more than 50 people and people who have rated more than 200 books.
    final_rating = final_rating[final_rating['no._of_total_ratings'] > 50]
    final_rating_test = final_rating_test[final_rating_test['no._of_total_ratings'] > 5]
    
    # remove duplicates
    final_rating.drop_duplicates(['user_id','title'],inplace = True)
    final_rating_test.drop_duplicates(['user_id','title'],inplace = True)

    # pivoting the dataframe
    book_pivot = final_rating.pivot_table(columns = 'user_id',index = 'title',values = 'rating')
    book_pivot.fillna(0,inplace=True)
    book_pivot_test = final_rating_test.pivot_table(columns = 'user_id',index = 'title',values = 'rating')
    book_pivot_test.fillna(0,inplace=True)
    
    similarity_score = cosine_similarity(book_pivot)
    similarity_score_test = cosine_similarity(book_pivot_test)

    book_title = Book.objects.get(pk=79)
    recommendations = recommend(book_title)

    book_rec_res = pd.DataFrame({'book':book_title, 'recommendations':recommendations})

    book_rec_res.to_csv('backend/storyconnect/book_rec/book_rec_res.csv',index=False)

    # book_based_rec = all_books_recommend(book_pivot, similarity_score)
    # return book_based_rec

def integrate_rec_into_models():
    book_based_rec = book_rec_book_based()

    for index, row in book_based_rec.iterrows():
        user_recommendations = book_based_rec[book_based_rec['book_id'] == row['book_id']]
        
        recs = []
        for rec in user_recommendations:
            recs.append(rec['recommendations'])
        book_rec = Book_Based_Rec.objects.get_or_create(user=row['book_id'], recommendation=recs)

def run():
    book_rec_book_based()
    # integrate_rec_into_models()

