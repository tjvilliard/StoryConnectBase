import numpy as np
import pandas as pd
import random

from sklearn.cluster import KMeans
from sklearn.mixture import GaussianMixture
from sklearn.decomposition import TruncatedSVD
from sklearn.metrics import silhouette_score
from sklearn.model_selection import train_test_split

from books.models import *
from comment.models import *
from models import *

def mean_ratings_for_n_books_user(n_num,test_set_ratings):
    mean_ratings_for_random_n = []

    # for each user, pick 10 books at random that the reader has rated and get the reader's average score for those books
    for index, row in test_set_ratings.iterrows():
        ratings_without_nas = row.dropna()
        random_n = ratings_without_nas.sample(n=n_num)
        random_n_mean = random_n.mean()
        mean_ratings_for_random_n.append(random_n_mean)

    # get the mean of the users' mean ratings for 10 random books each
    mean_benchmark_rating = sum(mean_ratings_for_random_n) / len(mean_ratings_for_random_n)
    return mean_benchmark_rating, mean_ratings_for_random_n

# get a list of the highest-rated books for each cluster
def get_cluster_favorites(preds, df_user_book_ratings, cluster_number):
    # create a list of cluster members
    cluster_membership = preds.index[preds['cluster'] == cluster_number].tolist()
    # build a dataframe of that cluster's book ratings
    cluster_ratings = df_user_book_ratings.loc[cluster_membership]
    # drop books that have fewer than 10 ratings by cluster members
    cluster_ratings = cluster_ratings.dropna(axis='columns', thresh=10)
    # find the cluster's mean rating overal and for each book
    means = cluster_ratings.mean(axis=0)
    # sort books by mean rating
    favorites = means.sort_values(ascending=False)
    return favorites

# for each cluster, determine the overall mean rating cluster members have given books
def get_cluster_mean(preds, df_ratings, cluster_number):
    # create a list of cluster members
    cluster_membership = preds.index[preds['cluster'] == cluster_number].tolist()
    # create a version of the original ratings dataset that only includes cluster members
    cluster_ratings = df_ratings[df_ratings['user_id'].isin(cluster_membership)]
    # get the mean rating
    return cluster_ratings['rating'].mean()

def recommend(cluster_assignments, user_id):
    user_cluster = cluster_assignments
    favorites = get_cluster_favorites(user_cluster).index
    favorites = random.choices(favorites, k=9)
    return favorites

def create_ratings_dataframe_personal(book_id, user_id):
    the_user = User.objects.get(id=user_id)
    the_user_ratings = WriterFeedback.objects.filter(user=the_user)
   
    # dummy df
    df_ratings_test = pd.DataFrame(
    {'user_id': [user_id],
    'book': [book_id],
    'rating': [3]})

    for user_rate in the_user_ratings:
        user_rating_entry = {
            'user_id': user_id,
            'book': book_id,
            'rating': user_rate.sentiment
        }
        df_ratings_test.append(user_rating_entry, ignore_index = True)

    return df_ratings_test

def create_ratings_dataframe():
    all_users = User.objects.all()
    
    # dummy df
    df_ratings_test = pd.DataFrame(
    {'user_id': [3],
    'book': [79],
    'rating': [3]})
    
    for each_user in all_users:
        the_user_ratings = WriterFeedback.objects.filter(user=each_user)

        for user_rate in the_user_ratings:
            user_rating_entry = {
                'user_id': each_user.pk,
                'book': user_rate.selection.chapter.book.pk,
                'rating': user_rate.sentiment
            }
            df_ratings_test.append(user_rating_entry, ignore_index = True)

    return df_ratings_test

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

def get_rec_for_all_users():
    # get recommendations for all users
    all_users = User.objects.all()

    user_based_rec = pd.DataFrame({
        'user_id' : [3],
        'recommendations' : [79]
    })
    for each_user in all_users:
        user_rec = {
            'user_id' : each_user.pk,
            'recommendations' : recommend(5, each_user.pk)
        }
        user_based_rec.append(user_rec, ignore_index=True)
    user_based_rec = user_based_rec.iloc[1:, :]
    return user_based_rec

def book_rec_user_based():
    # Load the dataset
    df_ratings = pd.read_csv('backend/storyconnect/book_rec/ratings.csv')
    df_books = pd.read_csv('backend/storyconnect/book_rec/book_data.csv')
    
    # find rating scaling equivalent
    df_ratings = df_ratings.assign(rating = df_ratings['rating'].apply(lambda x: 3 - ((x-1)/4 * (3-0+1)) ))

    # the_book = Book.objects.get(pk=book_id)
    # the_book_rating = Book_Rating.objects.get(book=the_book)
    # the_user = User.objects.get(id=user_id)
    
    # load data from database
    df_ratings_test = create_ratings_dataframe()
    df_book_test = create_book_dataframe()

    # Merge the two tables then pivot so we have Users X Books dataframe.
    df_book_ratings = pd.merge(df_ratings, df_books[['book_id', 'book_title']], on='book_id' )
    df_user_book_ratings = pd.pivot_table(df_book_ratings, index='user_id', columns= 'book_title', values='rating')
    df_book_ratings_test = pd.merge(df_ratings_test, df_book_test[['book_id', 'book_title']], on='book_id' )
    df_user_book_ratings_test = pd.pivot_table(df_book_ratings_test, index='user_id', columns= 'book_title', values='rating')

    # Drop users that have given fewer than 100 ratings of these most-rated books
    df_user_book_ratings = df_user_book_ratings.dropna(thresh=100)

    # replace NaN's with zeroes for Truncated SVD
    user_book_ratings_without_nan = df_user_book_ratings.fillna(0)
    user_book_ratings_test_without_nan = df_user_book_ratings_test.fillna(0)

    tsvd = TruncatedSVD(n_components=200, random_state=42)
    user_book_ratings_tsvd = tsvd.fit(user_book_ratings_without_nan).transform(user_book_ratings_without_nan)
    user_book_ratings_test_tsvd = tsvd.transform(user_book_ratings_test_without_nan)

    # view result in a Pandas dataframe, applying the original indices
    indices = df_user_book_ratings.index
    book_ratings_for_clustering = pd.DataFrame(data=user_book_ratings_tsvd).set_index(indices)

    book_ratings_training, book_ratings_testing = train_test_split(book_ratings_for_clustering, test_size=0.20, random_state=42)

    # find the per-book ratings of the test set
    test_model_indices = book_ratings_testing.index
    print(test_model_indices)
    test_set_ratings = df_user_book_ratings.loc[test_model_indices]

    # dataframe for clustering for database post-tsvd
    test_indices = df_user_book_ratings_test.index
    book_ratings_test_for_clustering = pd.DataFrame(data=user_book_ratings_test_tsvd).set_index(test_indices)

    mean_benchmark_rating, mean_ratings_for_random_10 = mean_ratings_for_n_books_user(10,test_set_ratings)
    mean_database_benchmark_rating, mean_database_ratings_for_random_10 = mean_ratings_for_n_books_user(10,df_user_book_ratings_test)

    print('Mean rating for 10 random books per test user: ', mean_benchmark_rating)
    print('Mean rating for 10 random books per test user from the database: ', mean_database_benchmark_rating)
    
    # trying with the training data after preprocessing
    clusterer_KMeans = KMeans(n_clusters=7).fit(book_ratings_training)
    preds_KMeans = clusterer_KMeans.predict(book_ratings_training)
    kmeans_score = silhouette_score(book_ratings_training, preds_KMeans)
    print("k_means score", kmeans_score)

    # trying with the training data after preprocessing
    clusterer_GMM = GaussianMixture(n_components=7).fit(book_ratings_training)
    preds_GMM = clusterer_GMM.predict(book_ratings_training)
    GMM_score = silhouette_score(book_ratings_training, preds_GMM)
    print("GMM score", GMM_score)

    indices = book_ratings_training.index
    preds = pd.DataFrame(data=preds_KMeans, columns=['cluster']).set_index(indices)

    clusters = [0, 1, 2, 3, 4, 5, 6]
    cluster_favorites = []
    cluster_of_books_mean = []
    for c in clusters:
        cluster_favorites.append(get_cluster_favorites(c))
        cluster_of_books_mean.append(get_cluster_mean(c))

    """# cluster0_books_storted = get_cluster_favorites(0)
    # cluster0_mean = get_cluster_mean(0)

    # print('The cluster 0 mean is:', cluster0_mean)
    # cluster0_books_storted[0:10]

    # cluster1_books_storted = get_cluster_favorites(1)
    # cluster1_mean = get_cluster_mean(1)

    # print('The cluster 1 mean is:', cluster1_mean)
    # cluster1_books_storted[0:10]

    # cluster2_books_storted = get_cluster_favorites(2)
    # cluster2_mean = get_cluster_mean(2)

    # print('The cluster 2 mean is:', cluster2_mean)
    # cluster2_books_storted[0:10]

    # cluster3_books_storted = get_cluster_favorites(3)
    # cluster3_mean = get_cluster_mean(3)

    # print('The cluster 3 mean is:', cluster3_mean)
    # cluster3_books_storted[0:10]

    # cluster4_books_storted = get_cluster_favorites(4)
    # cluster4_mean = get_cluster_mean(4)

    # print('The cluster 4 mean is:', cluster4_mean)
    # cluster4_books_storted[0:10]

    # cluster5_books_storted = get_cluster_favorites(5)
    # cluster5_mean = get_cluster_mean(5)

    # print('The cluster 5 mean is:', cluster5_mean)
    # cluster5_books_storted[0:10]

    # cluster6_books_storted = get_cluster_favorites(6)
    # cluster6_mean = get_cluster_mean(6)

    # print('The cluster 6 mean is:', cluster6_mean)
    # cluster6_books_storted[0:10]"""

    # associate each test user with a cluster
    test_set_preds = clusterer_KMeans.predict(book_ratings_testing)
    test_set_indices = book_ratings_testing.index
    test_set_clusters = pd.DataFrame(data=test_set_preds, columns=['cluster']).set_index(test_set_indices)

    # associate each test user from database with a cluster
    database_test_set_preds = clusterer_KMeans.predict(book_ratings_test_for_clustering)
    database_test_set_indices = book_ratings_test_for_clustering.index
    database_test_set_clusters = pd.DataFrame(data=database_test_set_preds, columns=['cluster']).set_index(database_test_set_indices)

    mean_database_ratings_for_cluster_favorites = []
    
    # for each user, find the 10 books the reader has rated that are the top-rated books of the cluster.
    # get the reader's average score for those books   
    def top_rated_books_from_cluster(test_set_ratings, test_set_clusters, cluster_favorites):
        mean_ratings_for_cluster_favorites = []
        for index, row in test_set_ratings.iterrows():
            user_cluster = test_set_clusters.loc[index, 'cluster']
            favorites = cluster_favorites[user_cluster].index
            user_ratings_of_favorites = []
            # proceed in order down the cluster's list of favorite books
            for book in favorites:
                # if the user has given the book a rating, save the rating to a list
                if np.isnan(row[book]) == False:
                    user_ratings_of_favorites.append(row[book])
                # stop when there are 10 ratings for the user
                if len(user_ratings_of_favorites) >= 10:
                    break
            # get the mean for the user's rating of the cluster's 10 favorite books
            mean_rating_for_favorites = sum(user_ratings_of_favorites) / len(user_ratings_of_favorites)
            mean_ratings_for_cluster_favorites.append(mean_rating_for_favorites)

        mean_favorites_rating = sum(mean_ratings_for_cluster_favorites) / len(mean_ratings_for_cluster_favorites)
        return mean_favorites_rating
    
    mean_favorites_rating = top_rated_books_from_cluster(test_set_ratings, test_set_clusters, cluster_favorites)
    mean_favorites_database_rating = top_rated_books_from_cluster(df_user_book_ratings_test, database_test_set_clusters, cluster_favorites)

    print('Mean rating for 10 random books per test user: ', mean_benchmark_rating)
    print('Mean rarting for 10 books that are the cluster\'s favorites: ', mean_favorites_rating)
    print('Difference between ratings: ', mean_favorites_rating-mean_benchmark_rating)
    
    print('Mean rating for 10 random books per test user from database: ', mean_database_benchmark_rating)
    print('Mean rarting for 10 books that are the cluster\'s favorites: ', mean_favorites_database_rating)
    print('Difference between ratings: ', mean_favorites_database_rating-mean_database_benchmark_rating)

    # recommendation8667 = recommend(5, 8667)
    # print(recommendation8667)
    user_based_rec = get_rec_for_all_users()

    return user_based_rec

def integrate_rec_into_models():
    user_based_rec = book_rec_user_based()

    for index, row in user_based_rec.iterrows():
        user_recommendations = user_based_rec[user_based_rec['user_id'] == row['user_id']]
        
        recs = []
        for rec in user_recommendations:
            recs.append(rec['recommendations'])
        user_rec = User_Based_Rec.objects.get_or_create(user=row['user_id'], recommendation=recs)

def run():
    integrate_rec_into_models()

"""# recommendation27229 = recommend(test_set_clusters, user_book_ratings, 27229)
# recommendation31159 = recommend(test_set_clusters, user_book_ratings, 31159)
# recommendation10579 = recommend(test_set_clusters, user_book_ratings, 10579)
# recommendation8667 = recommend(test_set_clusters, user_book_ratings, 8667)

# print('Recommendation for user 27229: ', recommendation27229)
# print('Recommendation for user 31159: ', recommendation31159)
# print('Recommendation for user 10579: ', recommendation10579)
# print('Recommendation for user 8667: ', recommendation8667)"""

