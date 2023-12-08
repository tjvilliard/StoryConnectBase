import joblib
import string
from sklearn.feature_extraction.text import TfidfVectorizer
import pandas as pd
import nltk
from nltk import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
import re
import numpy as np
from sklearn.preprocessing import LabelEncoder

from books.models import *
from features.models import *

nltk.download('punkt')
nltk.download('stopwords')

import warnings
warnings.filterwarnings('ignore')  # "error", "ignore", "always", "default", "module" or "once"

df=pd.read_csv('scripts/data.csv',index_col='index')
print(df.head())

# text = input("Enter text: ")
book_id = input("Enter book id: ")

    # load data for prediction
predict_books = Book.objects.get(pk=book_id)
book_id = predict_books.pk
book_title = predict_books.title
# book_chapters = Chapter.objects.filter(book = predict_books)
# predict_chapter = Chapter.objects.get(book=predict_books, chapter_number = chapter_num)

chapter_df = pd.DataFrame({'book': [book_id],
    'book_title': [book_title],
    # 'chapter_number': [predict_chapter.chapter_number],
    'content': [str(predict_books.synopsis)]})

# text = str(text)

cleaned_text = re.sub('[^A-Za-z0-9\s]', '', str(predict_books.synopsis))

# genre=input("Enter genre: ")
# genre=str(genre)
# title=input("Enter title: ")
# title=str(title)

df_text = pd.DataFrame({'title':[book_title],'text':[cleaned_text]})
# df_text['genre'] = df_text['genre'].apply(lambda x: np.NaN if len(x) == 0 else x)

# The below function comes in handy to count the number of characters in a text
def char_count(text):
    charc=0
    for char in text.split():
        charc +=len(char)
    return charc

#Generating the column title_char_len
df_text = df_text.assign(title_char_len = df_text['title'].apply(char_count))
df_text.head()

df_text = df_text.assign(book_title_len = df_text['title'].apply(lambda x: len(x.split())))
df_text.head()

df_text = df_text.assign(summary_len=df_text['text'].apply(lambda x:len(x.split())))
df_text = df_text.assign(summary_char_len=df_text['text'].apply(char_count))

df_text['Combined_Text']=df_text['title'] + ' ' + df_text['text']

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

# df_text.drop(columns=['genre'],inplace=True)

pt_lst = []
for text in df_text['text']:
  processed_text = remove_stopwords(clean_words(convertintolist(text)))
  pt_lst.append(processed_text)
  # df = df.loc[index, 'Combined_Text'] = processed_text  # assigns processed to the cell at row index and column 'Combined_Text'
  # df = df.assign(Combined_text=df['Combined_Text'].apply(lambda x:processed_text))

df_text['text'] = pt_lst
df_text.head()

df_text = df_text['Combined_Text']

#Encoding the genre column
encoder=LabelEncoder()
df['genre']=encoder.fit_transform(df['genre'].values)

tfidf_mod=joblib.load('scripts/tfidf_model.joblib')
xtest2=tfidf_mod.transform(df_text).toarray()

# X_train=tfidf_mod.transform(X_train).toarray()
xtest2 = tfidf_mod.transform(df_text).toarray()

reg = joblib.load('scripts/lg_model.joblib')
lg_text_pred_test2 = reg.predict(xtest2)

# encoder2=joblib.load('/content/sample_data/encoder_model.joblib')
# df['genre'] = encoder2.transform(df['genre'].values)

lg_text_pred_test2 = encoder.inverse_transform(lg_text_pred_test2)
print("genre predicted: ", lg_text_pred_test2)



# with open('/content/drive/MyDrive/Fall2023/CS4500/text_placeholder.txt', 'r') as file:
#     messy_text = file.read()
# import re

# cleaned_text = re.sub('[^A-Za-z0-9\s]', '', messy_text)