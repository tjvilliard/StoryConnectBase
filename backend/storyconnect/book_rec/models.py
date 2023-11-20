from django.db import models
from books import models as book_model
from comment import models as comment_model
from django.contrib.auth.models import User
from django.contrib.postgres.fields import ArrayField

# Create your models here.
class Book_Based_Rec(models.Model):
    book = models.ForeignKey(book_model.Book, on_delete=models.CASCADE)
    recommendations = ArrayField(models.IntegerField(max_length=50), default=list(), blank=True, null=True)

class User_Based_Rec(models.Model):
    user = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)
    recommendations = ArrayField(models.CharField(max_length=50), default=list(), blank=True, null=True)


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
        
    # def save(self, *args, **kwargs):
    #     if not self.pk:  # check if the instance is not yet saved to the database
    #         the_book_rating = Book_Rating.objects.filter(book=self.book).first()
    #         if the_book_rating:
    #             self.rating = the_book_rating.get_rating()
    #     super().save(*args, **kwargs)