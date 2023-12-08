from django.db import models
from books.models import  Book, Chapter
from django.contrib.postgres.fields import ArrayField
from django.contrib.auth.models import User
from django.core.validators import MaxValueValidator, MinValueValidator

# Create your models here.
class Review(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    commenter = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)
    content = models.TextField(blank=True)
    # rating = models.FloatField(min = 0.0, max = 5.0) # , widget=forms.NumberInput(attrs={'step': 0.5})
    rating = models.IntegerField(default=0,validators=[MaxValueValidator(5), MinValueValidator(0)])
    class Meta:
            constraints = [
                models.CheckConstraint(
                    check=models.Q(rating__gte=0) & models.Q(rating__lt=5),
                    name="A qty value is valid between 1 and 10",
                )
            ]
    def __str__(self):
        return f"{self.content}: {self.rating}"
    
    def average_rating(self, book_id) -> float:
        thebook = Book.objects.get(pk=book_id)
        return Review.objects.filter(pk=thebook).aggregate(models.Avg("rating"))["rating__avg"] or 0

class GenreTagging(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    genre = ArrayField(models.CharField(max_length=50), blank=True, null=True)

class ChapterTagging(models.Model):
    # book = models.ForeignKey(Book, on_delete=models.CASCADE)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
    last_chapter_len = models.IntegerField(default=0)
    genre = ArrayField(models.CharField(max_length=50), blank=True, null=True)
        