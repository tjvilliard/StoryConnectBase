import pandas as pd
import numpy as np
import copy
import nltk
nltk.download('stopwords')
from nltk.corpus import stopwords
from sklearn.metrics.pairwise import linear_kernel
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer
from nltk.tokenize import RegexpTokenizer
import re
import string
from sklearn.metrics.pairwise import cosine_similarity

from books import models as book_models
from book_rec import models as bookrec_models

import warnings
warnings.filterwarnings('ignore')  # "error", "ignore", "always", "default", "module" or "once"


def _removeNonAscii(s):
    return "".join(i for i in s if  ord(i)<128)

def make_lower_case(text):
    return text.lower()

def remove_stop_words(text):
    text = text.split()
    stops = set(stopwords.words("english"))
    text = [w for w in text if not w in stops and w not in ['na', 'la'] and len(w)>1]
    text = " ".join(text)
    return text

def remove_html(text):
    html_pattern = re.compile('<.*?>')
    return html_pattern.sub(r'', text)

def remove_punctuation(text):
    tokenizer = RegexpTokenizer(r'\w+')
    text = tokenizer.tokenize(text)
    text = " ".join(text)
    return text

# Function for recommending books based on Book title. It takes book title and genre as an input.
import copy
# Function for recommending books based on Book title. It takes book title and genre as an input.
def recommend(df,id, title):
    
    global rec
    # Matching the genre with the dataset and reset the index
    # data = df.loc[df['genre'] == genre]  
    data = copy.deepcopy(df)
    data.reset_index(level = 0, inplace = True) 

    # Convert the index into series
    indices = pd.Series(data.index, index = data['id'])
    
    #Converting the book description into vectors and used bigram
    tf = TfidfVectorizer(analyzer='word', ngram_range=(2, 2), min_df = 1, stop_words='english')
    tfidf_matrix = tf.fit_transform(data['cleaned'])
    
    # Calculating the similarity measures based on Cosine Similarity
    sg = cosine_similarity(tfidf_matrix, tfidf_matrix)
    
    # Get the index corresponding to original_title
       
    idx = indices[id]
    title_idx = data.loc[data['id'] == id].iloc[0]
    print(title_idx)

    # Get the pairwsie similarity scores 
    sig = list(enumerate(sg[idx]))
    # Sort the books
    sig = sorted(sig, key=lambda x: x[1], reverse=True)
    # Scores of the 5 most similar books 
    sig = sig[1:15]
    # Book indicies
    movie_indices = [i[0] for i in sig]
   
    # Top 5 book recommendation
    rec = data[['title', 'desc', 'id']].iloc[movie_indices]
    
    df_rec = pd.DataFrame(columns=['id','title','recommendation', 'rec_id'])
    # title_col = np.full(len(df_rec['recommendation'].values), fill_value=title)
    # df_rec.id = df_rec.id.astype('int32') 

    for index, row in rec.iterrows():
        rec_entry = {'id':title_idx['id'], 'title': title,'recommendation' :row['title'], 'rec_id':row['id']}
        df_rec = df_rec.append(rec_entry, ignore_index=True)
    return df_rec
    # return df_rec
    # It reads the top 5 recommend book url and print the images
    # for i in rec['title']:
    #   print(i)
    # for i in rec['url']:
    #     response = requests.get(i)
    #     img = Image.open(BytesIO(response.content))
    #     plt.figure()
    #     print(plt.imshow(img))

def create_df():
    all_books = book_models.Book.objects.all()
    df = pd.DataFrame({'id': [84],'title':["The Last Day of Pompeii"], 'desc':["book_desc of pompeii"],})
    for each_book in all_books:
        book_id = each_book.pk
        book_title = each_book.title
        book_desc = each_book.synopsis
        book_entry = {'id': book_id,'title':book_title, 'desc':book_desc}
        df = df.append(book_entry, ignore_index=True)
    df = df.iloc[1:, :]
    return df

def recommend_all_books(df):
     for index, row in df.iterrows():
        the_book,created = book_models.Book.objects.get_or_create(pk=row['id'])
        user,created = book_models.User.objects.get_or_create(pk=the_book.user.pk)
        df_rec = recommend(df, row['id'], row['title'])
        rec_lst = list(df_rec['rec_id'])
        print("rec_lst", rec_lst)
        get_book_recs = book_models.Book.objects.filter(pk__in=rec_lst)
        print('get_book_recs',get_book_recs )
        for rec in get_book_recs:
            print("rec", rec)
            book_rec=bookrec_models.Book_Based_Rec.objects.create(book=the_book, recommendations=rec)
            print("book_rec",book_rec)
            print("book title from clustering: ",the_book.title)

def recommend_user(df):
    all_users = book_models.User.objects.all()
    for each_user in all_users:
        check_lib = book_models.Library.objects.filter(reader=each_user).count()
        if check_lib > 0:
            user_lib,created = book_models.Library.objects.filter(reader=each_user)
            print("a")
            for each_lib in user_lib:
                user_rec, created = book_models.Library.objects.get_or_create(library = each_lib, reader=each_user)
                print("b")
                user_rec_book = user_rec.book
                book_recs = bookrec_models.Book_Based_Rec.objects.filter(book=user_rec_book)
                print("c")
                for each_rec in book_recs:
                    user_based_rec, created = bookrec_models.User_Based_Rec.objects.get_or_create(library=each_lib, recommendations=each_rec.recommendations)
                    print("userbasedrec: ",user_based_rec.library)

def recommend_modified(df):
    frames = []
    for index, row in df.iterrows():
        the_book,created = book_models.Book.objects.get_or_create(pk=row['id'])
        user,created = book_models.User.objects.get_or_create(pk=the_book.user.pk)
        df_rec_tmp = recommend(df, row['id'], row['title'])
        rec_lst = list(df_rec_tmp['rec_id'])
        frames.append(df_rec_tmp)
        # df_rec.to_csv('book_rec_table.csv')
    df_rec = pd.concat(frames, axis=0)
    
    return df_rec
        # for each_rec_id in rec_lst:
        #     book_rec,created = bookrec_models.Book_Based_Rec.objects.get_or_create(book=the_book,recommendations = int(each_rec_id))



def cluster_content():
    """Dataframe Formatting"""

    # Reading the data
    # df = pd.read_csv("/content/drive/MyDrive/Fall2023/CS4500/bookrecmodified/data.csv", index_col=0)
    df = create_df()
    # df = df.loc[:, ~df.columns.str.contains('^Unnamed')]
    # df.rename(columns={'Desc':'desc'}, inplace=True)
    # df.drop(columns=['image_link'], inplace=True)
    # df['desc'] = df['desc'].astype(str)

    """# Text Preprocessing"""
    #Utitlity functions for removing ASCII characters, converting lower case, removing stop words, html and punctuation from description

    df['cleaned'] = df['desc'].apply(_removeNonAscii)
    df['cleaned'] = df.cleaned.apply(func = make_lower_case)
    df['cleaned'] = df.cleaned.apply(func = remove_stop_words)
    df['cleaned'] = df.cleaned.apply(func=remove_punctuation)
    df['cleaned'] = df.cleaned.apply(func=remove_html)
    
    # recommend_all_books(df)
    # recommend_user(df)
    df_rec = recommend_modified(df)
    return df_rec

def run():
    df_rec = cluster_content()
    df_rec.to_csv('bookrec_data.csv')
    print("finished.")
