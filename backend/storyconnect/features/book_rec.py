from books.models import *
from django.db.models import Count

import itertools
import pandas as pd
from openpyxl import Workbook
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA

def general_rec():
#     all_books_in_reading = Library.objects.all(status=1)

#     trending_books = {}
#     for b in all_books_in_reading:
#         book_id = b.book.pk
    books_count = Library.objects.filter(status=1,).order_by('book').values('book__pk').annotate(count=Count('book__name'))
    books_count_dict = {books_count['book__pk']: books_count['count'] for f in trending_books}
    # [{'count': 3, 'category__name': u'category1'}, {'count': 1, 'category__name': u'category2'}]

    trending_books = sorted(books_count_dict.items(),key=lambda x:x[1], reverse=True)[0:20]
    trending_books_dict = dict(trending_books)

    trending_books_objects = []
    for book in trending_books_dict.values():
        tr_book = Book.objects.get(pk = book)
        trending_books_objects.append(tr_book)

    return trending_books_objects

def personal_rec(user_id):
    personal_books_in_library = Library.objects.filter(reader=User.objects.get(id=user_id))

def jaccard_simp(list, data_f):
    points = []
    for pair in list:
        # print(dict_c[pair[0]])
        # print(dict_c[pair[1]])
        content_set_a = set(data_f[pair[0]][6])
        content_set_b = set(data_f[pair[1]][6])
        content_sim = len(content_set_a.intersection(content_set_b))/len(content_set_a.union(content_set_b))
        # print(content_sim)
        cat_set_a = set(data_f[pair[0]][3])
        cat_set_b = set(data_f[pair[1]][3])
        cat_sim = len(cat_set_a.intersection(cat_set_b)) / len(cat_set_a.union(cat_set_b))
        # print(cat_sim)
        pair_value = (content_sim,cat_sim)
        points.append(pair_value)
    return points

def jaccard_simp_one(list, start_key, data_f):
    points = []
    for key in list:
        if key == start_key:
            continue
        name = data_f[key][0]
        # print(dict_c[pair[0]])
        # print(dict_c[pair[1]])
        content_set_a = set(data_f[start_key][6])
        content_set_b = set(data_f[key][6])
        content_sim = len(content_set_a.intersection(content_set_b))/len(content_set_a.union(content_set_b))
        # print(content_sim)
        cat_set_a = set(data_f[start_key][3])
        cat_set_b = set(data_f[key][3])
        cat_sim = len(cat_set_a.intersection(cat_set_b)) / len(cat_set_a.union(cat_set_b))
        # print(cat_sim)
        # pair_value = (key, name, content_sim,cat_sim)
        pair_value = (content_sim,cat_sim)
        points.append(pair_value)
    return points

def content_rec():
    all_books = Book.objects.all()
    all_books_id_genre = {}
    for book in all_books:
        book_id = book.pk
        all_books_id_genre[book_id] = book.tags
    
    chapter_book = {}
    for book_id in all_books_id_genre:
        chapters = Chapter.objects.filter(book=book_id)
        ch_b = []
        for chapter in chapters:
            ch = chapter.content
            ch_b.append(ch)
        chapter_book[book_id] = ch_b
    
    chps_b = {}
    for chap in chapter_book.values():
        chps = {}
        for i,chp in enumerate(chap):
            vectorizer = CountVectorizer()
            X = vectorizer.fit_transform(chp)
            chps[i] = vectorizer.get_feature_names_out()
        chps_b[chapter_book[chap.keys()]]
    
    res = list(itertools.combinations(chps_b, 2))
    keys = chps_b.keys()
    keys = list(keys)[1:]

    js = jaccard_simp_one(keys, '78', data_f)
    data_f = pd.DataFrame(js)
    data_f.columns = ['chapter', 'tags']

    # data_f = data_f.sort_values(by='category_js', ascending=False)
    # data_f = data_f.head(5)
 
    pca = PCA(n_components=3)
    pca.fit(data_f)
    pca_fit = pca.transform(data_f)
    pca_fit = pd.DataFrame(pca_fit,index=data_f.index)

    TSS = []
    for i in range(2,26):
        km = KMeans(n_clusters=i,random_state=0)
        km.fit(pca_fit)
        TSS.append(km.inertia_)

    # apply K-means clustering
    kmeans = KMeans(n_clusters=2, random_state=0)
    kmeans.fit(data_f)
    labels = kmeans.labels_
    centers = kmeans.cluster_centers_

    # add cluster labels to dataframe
    data_f['label'] = labels

    # # plot the clusters using different colors for each cluster
    # fig, ax = plt.subplots(figsize=(8, 6))
    # colors = ['r', 'g'] # change colors as needed
    # for i in range(2): # 4 is the number of clusters
    #     cluster = df[df['label'] == i]
    #     ax.scatter(cluster['content_js'], cluster['category_js'], c=colors[i], label=f'Cluster {i+1}')
    # ax.set_xlabel('Book Content Jaccard Similarity Score')
    # ax.set_ylabel('Book Genres Jaccard Similarity Score')
    # ax.set_title('K-means clustering with k=2 for A Room with a View by E. M. Forster')
    # ax.legend()
    # plt.show()






