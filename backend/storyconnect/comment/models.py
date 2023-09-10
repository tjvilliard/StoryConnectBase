from django.db import models
from django.contrib.auth.models import User
from django_extensions.db.models import TimeStampedModel
from books.models import Book, Chapter


class Comment(TimeStampedModel):
    user = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)

    chapter = models.ForeignKey(Chapter, null=True,blank=True,  on_delete=models.CASCADE)
    offset = models.IntegerField(default=0)
    comment = models.TextField(max_length=1000, null=True, blank=True)
    
    
    def __str__(self):
        return self.comment
    
class Annotation(models.Model):
    comment = models.ForeignKey(Comment, null=True,blank=True,  on_delete=models.CASCADE)

class Highlight(models.Model):
    user = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)
    chapter = models.ForeignKey(Chapter, null=True,blank=True,  on_delete=models.CASCADE)
    
    chapter_offset = models.IntegerField(default=0)
    length = models.IntegerField(default=0)
    text = models.TextField(max_length=1000, null=True, blank=True)
    color = models.CharField(max_length=100, null=True, blank=True)

    def __str__(self):
        return self.text