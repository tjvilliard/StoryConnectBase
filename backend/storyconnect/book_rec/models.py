from django.db import models
from django.contrib.auth.models import User
from django.contrib.postgres.fields import ArrayField

from books import models as book_model
from comment import models as comment_model

class Book_Based_Rec(models.Model):
    book = models.ForeignKey(book_model.Book, on_delete=models.CASCADE)
    recommendations = ArrayField(models.IntegerField(), blank=True, null=True, default=list)

class User_Based_Rec(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    recommendations = ArrayField(models.IntegerField(), blank=True, null=True, default=list)

class Book_Rating(models.Model):
    book = models.ForeignKey(book_model.Book, on_delete=models.CASCADE)
    rating = models.FloatField(default=3)

    def get_rating(self):
        book_chapters = book_model.Chapter.objects.filter(book = self.book)

        book_chapter_ratings = []
        for chapter in book_chapters:
            all_comments_in_chapter = comment_model.WriterFeedback.objects.filter(selection__chapter__id=chapter.pk)
            
            chapter_ratings = []
            for chapter_comment in all_comments_in_chapter:
                chapter_rating = chapter_comment.sentiment
                chapter_ratings.append(chapter_rating)
            
            mean_chapter_rate = sum(chapter_ratings)/len(chapter_ratings)
            book_chapter_ratings.append(mean_chapter_rate)
            

        book_rating = sum(book_chapter_ratings)/len(book_chapter_ratings)
        return book_rating