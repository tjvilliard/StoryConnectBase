from django.db import models
from django.contrib.auth.models import User
from django_extensions.db.models import TimeStampedModel
from books.models import Chapter
from .managers import CommentManager


class TextSelection(TimeStampedModel):
    chapter = models.ForeignKey(Chapter, null=True,blank=True,  on_delete=models.CASCADE)
    offset = models.IntegerField(default=0)
    length = models.IntegerField(default=0)
    text = models.TextField(max_length=1000, null=True, blank=True)
    floatng = models.BooleanField(default=False)




    
class Comment(models.Model):
    objects = CommentManager()

    user = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)
    selection = models.ForeignKey(TextSelection, null=True,blank=True,  on_delete=models.CASCADE)
    content = models.TextField(max_length=1000, null=True, blank=True)
    parent = models.ForeignKey('self', null=True,blank=True,  on_delete=models.CASCADE)

    posted = models.DateTimeField(auto_now_add=True)
    edited = models.DateTimeField(auto_now=True)

    dismissed = models.BooleanField(default=False)

    suggestion = models.TextField(max_length=1000, null=True, blank=True)

    def __str__(self):
        return f'{self.user} -- {self.selection.chapter}'
    
    def get_receiver(self):
        chapter = self.selection.chapter
        book = chapter.book
        return book.owner
    
    @property
    def is_suggestion(self):
        return self.suggestion != None
    
    @property
    def is_ghost(self):
        return self.selection.floating == True
    

# class Suggestion(models.Model):
#     user = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)
#     selection = models.ForeignKey(TextSelection, null=True,blank=True,  on_delete=models.CASCADE)
#     suggestion = models.TextField(max_length=1000, null=True, blank=True)

#     def __str__(self):
#         return self.suggestion
    
class Annotation(models.Model):
    user = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)
    selection = models.ForeignKey(TextSelection, null=True,blank=True,  on_delete=models.CASCADE)
    annotation = models.TextField(max_length=1000, null=True, blank=True)

class Highlight(models.Model):
    user = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)
    selection = models.ForeignKey(TextSelection, null=True,blank=True,  on_delete=models.CASCADE)
    color = models.CharField(max_length=100, null=True, blank=True)

    def __str__(self):
        return self.text