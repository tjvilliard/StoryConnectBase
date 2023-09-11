from django.db import models
from django.contrib.auth.models import User
from django_extensions.db.models import TimeStampedModel
from books.models import Chapter

class TextSelection(TimeStampedModel):
    chapter = models.ForeignKey(Chapter, null=True,blank=True,  on_delete=models.CASCADE)
    offset = models.IntegerField(default=0)
    length = models.IntegerField(default=0)
    text = models.TextField(max_length=1000, null=True, blank=True)
    floatng = models.BooleanField(default=False)

class Comment(models.Model):
    user = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)
    selection = models.ForeignKey(TextSelection, null=True,blank=True,  on_delete=models.CASCADE)
    content = models.TextField(max_length=1000, null=True, blank=True)
    parent = models.ForeignKey('self', null=True,blank=True,  on_delete=models.CASCADE)

    def __str__(self):
        return self.comment
    
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