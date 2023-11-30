# python manage.py runscript delete_all_questions

# from django.contrib.auth.signals import user_logged_out
# from django.core.signals import request_finished
from logging import getLogger
from features import content_tagging as ct
from features import models as features_models
from books import models as book_models
# from django.dispatch import receiver
from django.contrib.auth.models import User
# from django_postgres_extensions.models.functions import *

# @receiver(user_logged_out, sender=User)
# def user_logged_out_callback(sender, user, request, **kwargs):
logger = getLogger('__name__')
#     logger.info('signal received log out')
#     print("log out")
#     all_user_books = book_models.Book.objects.filter(user=user)
#     for book in all_user_books:
#         book_genretag,created = features_models.GenreTagging.objects.get_or_create(book=book)
#         book_genre, created = book_models.Book.objects.get_or_create(pk=book.pk)
#         chapters_genres = []
#         for chap in book.get_chapters():
#             chapter_genre, created = features_models.ChapterTagging.objects.get_or_create(chapter = chap.pk)
#             updated_chapter_len = len(chap.content)
#             if updated_chapter_len >= 2*chapter_genre.last_chapter_len and updated_chapter_len>=1000:
#                 chapter_df = ct.predict_genre(book_id=book, chapter_num=chap.chapter_number)
#                 generated_genre = chapter_df['genre'].values()
#                 chapter_genre.genre = generated_genre
#                 chapters_genres.append(chapter_genre)
#             chapter_genre.last_chapter_len = updated_chapter_len
#             break
        
#         genres_of_the_book_from_book_model = book_genre.tags
#         # genres_of_the_book_from_book_model = book_models.Book._meta.get_field('tags').value_from_object(book_genre)
#         tmp_lst = genres_of_the_book_from_book_model
#         for genre in chapters_genres:
#             if genre not in (book_genretag.genre or genres_of_the_book_from_book_model):
#                 tmp_lst.append(genre)
        
#         features_models.GenreTagging.objects.filter(book=book_genretag).update(genre=tmp_lst)
#         book_models.Book.objects.filter(pk=book_genre).update(tags=tmp_lst)
#         print("finished.")

def contenttag_test():
    me, created = User.objects.get_or_create(pk=11)
    
    all_user_books = book_models.Book.objects.filter(user=me)
    for book in all_user_books:
        book_genretag,created = features_models.GenreTag.objects.get_or_create(book=book)
        book_genre, created = book_models.Book.objects.get_or_create(pk=book.pk)
        chapters_genres = []
        for chap in book.get_chapters():
            chapter_genre, created = features_models.ChapterTagging.objects.get_or_create(chapter = chap.pk)
            updated_chapter_len = len(chap.content)
            if updated_chapter_len >= 2*chapter_genre.last_chapter_len and updated_chapter_len>=1000:
                chapter_df = ct.predict_genre(book_id=book, chapter_num=chap.chapter_number)
                generated_genre = chapter_df['genre'].values()
                chapter_genre.genre = generated_genre
                chapters_genres.append(chapter_genre)
            chapter_genre.last_chapter_len = updated_chapter_len
        
        # genres_of_the_book_from_book_model = book_genre.tags
        # genres_of_the_book_from_book_model = book_models.Book._meta.get_field('tags').value_from_object(book_genre)
        
        # check if the genres in both models are the same
        genre_from_tag = book_genretag.genre
        genre_from_book = book_genre.tags

        if genre_from_book != genre_from_tag:
            book_genre = set(genre_from_book+genre_from_tag)
        else:
            book_genre = genre_from_book

        # collect the added genres
        added_genres = set()
        for genre in chapters_genres:
            if genre not in book_genre:
                added_genres.add(genre)
        book_genre = book_genre.union(added_genres)

        # update the book genre with the additional genres
        features_models.GenreTag.objects.filter(book=book_genretag).update(genre=book_genre)
        book_models.Book.objects.filter(pk=book_genre).update(tags=book_genre)
        print("finished.")

def run():
    contenttag_test()
    logger.info('content tagging finished.')