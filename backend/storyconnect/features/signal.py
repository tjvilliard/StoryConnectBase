from django.contrib.auth.signals import user_logged_out
from logging import getLogger
from features import content_tagging as ct
from features import models as features_models
from books import models as book_models
from django.dispatch import receiver
from django.contrib.auth.models import User

@receiver(user_logged_out, sender=User)
def user_logged_out_callback(sender, user, request):
    logger = getLogger('user')
    logger.info('User {} logged out.'.format(request.user.username))
    print("user log out")
    all_user_books = book_models.Book.objects.filter(owner=user)
    for book in all_user_books:
        book_genre,created = features_models.GenreTagging.objects.get_or_create(book=book)

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
            break

        for genre in chapters_genres:
            if genre not in book_genre.genre:
                book_genre.genre.append(genre)