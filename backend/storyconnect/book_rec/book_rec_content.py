import pandas as pd
# pd.set_option('display.max_columns', 30)
# pd.set_option('display.width', 100)
# pd.set_option('display.expand_frame_repr', False)
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

import warnings
warnings.filterwarnings('ignore')

def book_title(book_id):
    book_title = df[df["book_id"]==book_id]["book_title"].values[0]
    print(book_title)

def Content_Based_Recommendation(df,col):
    
    tfidf = TfidfVectorizer(stop_words="english")
    # TfidfVectorizer , dilde yaygınca kullanılan ve ölçüm değeri taşımayan ve yaygın kullanılan kelimeleri vs. siler
    df[col] = df[col].fillna('')
    tfidf_matrix = tfidf.fit_transform(df[col])
    
    cosine_sim = cosine_similarity(tfidf_matrix,
                                   tfidf_matrix)

    
    df2=pd.DataFrame(cosine_sim)
    df2.index=df['book_id']
    df2.columns=df['book_id']
    
    
    if col=="book_desc":
        df2=book_desc_empty_fiil_mean(df,df2)
    
    
    return df2

def similarity_scores_(df2,book_id):
    similarity_scores=df2[book_id]
    similarity_scores=pd.DataFrame(similarity_scores)
    similarity_scores.columns=["score"]
    similarity_scores=similarity_scores.sort_values("score", ascending=False)
    return similarity_scores
    
def Recommended_book(similarity_scores,df):
    Recommended_book_ids = similarity_scores.index
    df_Recommended=df[["book_id","book_title","book_series","book_authors","genres"]]
    df_Recommended.index=df_Recommended["book_id"]
    df_Recommended=df_Recommended.loc[Recommended_book_ids]

    return df_Recommended

def fig_plot(recommend_book,df,col):
    fig, axs = plt.subplots(1, 5,figsize=(18,5))
    fig.suptitle('Seçtiğimiz {}'.format(book_title)+ ' kitabın' + ' {}'.format(col) + ' uygun tavsiyelerimiz:', color="#4C0099",size = 10)
    for i in range(5):

                    url = df.loc[df['book_title'] == recommend_book['book_title'].tolist()[i],'image_url_x'][:1].values[0]
                    im = Image.open(requests.get(url, stream=True).raw)
                    axs[i].imshow(im)
                    axs[i].axis("off")
                    axs[i].set_title('{}'.format(recommend_book['book_title'].tolist()[i]), y=-0.18,color="#4C0099",fontsize=14)

    fig.show()

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

def Special_Content_Recommender(df,col,book_id):
    content_txt =Content_Based_Recommendation(df,col)
    similarity_scores_txt = similarity_scores_(content_txt,book_id)
    Recommend_txt = Recommended_book(similarity_scores_txt,df)
    Recommend_txt["similarity_scores"] = similarity_scores_txt
    print(Recommend_txt.iloc[:15])
    # fig_plot(Recommend_txt,df,col)

def main():
    df= pd.read_csv('backend/storyconnect/book_rec/general_book_rec_dataset/goodbooks_10k_rating_and_description.csv')
