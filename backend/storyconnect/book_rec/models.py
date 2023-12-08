from django.db import models
from django.contrib.auth.models import User
from django.contrib.postgres.fields import ArrayField

from books import models as book_model
from comment import models as comment_model

# class Group(models.Model):
#     # name = models.CharField(max_length=128)
#     members = models.ManyToManyField(
#         book_model.Book,
#         through='Book_Based_Rec',
#         through_fields=('group', 'book'),
#     )

class Book_Based_Rec(models.Model):
    # group = models.ForeignKey(Group, on_delete=models.CASCADE)
    book = models.ForeignKey(book_model.Book, on_delete=models.CASCADE, related_name="book")
    # placeholder = models.CharField(default="", blank=True, null=True)
    recommendations = models.IntegerField( blank=True, null=True)
    # recommendations = models.ForeignKey(book_model.Book,on_delete=models.CASCADE,blank=True, related_name="recommendations")
    tmp = models.CharField(null=True,blank=True, default="")

    # def __str__(self):
    #         return f'{self.book} -> {self.recommendations.name}'
    
class User_Based_Rec(models.Model):
    library = models.ForeignKey(book_model.Library, on_delete=models.CASCADE)
    recommendations = models.ForeignKey(Book_Based_Rec, on_delete=models.CASCADE,blank=True,null=True)
    # recommendations = ArrayField(models.IntegerField(), blank=True, null=True, default=list)
    # recommendations = models.ForeignKey(book_model.Book, on_delete=models.CASCADE)

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