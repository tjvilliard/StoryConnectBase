from django.db import models
from django.contrib.auth.models import User
from django_extensions.db.models import TimeStampedModel
from books.models import Chapter
from .managers import WriterFeedbackManager


class TextSelection(models.Model):
    chapter = models.ForeignKey(Chapter, null=True,blank=True,  on_delete=models.CASCADE)
    offset = models.IntegerField(default=0)
    offset_end = models.IntegerField(default=0)
    text = models.TextField(max_length=1000, null=True, blank=True)
    floating = models.BooleanField(default=False)



class WriterFeedback(models.Model): # writer feedback 
    objects = WriterFeedbackManager()

    # User should be required
    user = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)

    # Selection should be required
    selection = models.OneToOneField(TextSelection, on_delete=models.CASCADE)

    comment = models.TextField(max_length=1000, null=True, blank=True)
    parent = models.ForeignKey('self', null=True,blank=True,  on_delete=models.CASCADE)

    SENTIMENT_CHOICES = [
        (0, 'Great'),
        (1, 'Good'),
        (2, 'Mediocre'),
        (3, 'Bad')
    ]
    sentiment = models.IntegerField(choices=SENTIMENT_CHOICES, null=True, blank=True)

    dismissed = models.BooleanField(default=False)

    suggestion = models.BooleanField(default=False)

    posted = models.DateTimeField(auto_now_add=True)
    edited = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'{self.user} -- {self.selection.chapter}'
    
    def get_receiver(self):
        chapter = self.selection.chapter
        book = chapter.book
        return book.owner
    

    @property
    def is_ghost(self):
        if self.selection:
            return self.selection.floating == True
        
        return False
    

# class Suggestion(models.Model):
#     user = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)
#     selection = models.ForeignKey(TextSelection, null=True,blank=True,  on_delete=models.CASCADE)
#     suggestion = models.TextField(max_length=1000, null=True, blank=True)

#     def __str__(self):
#         return self.suggestion
    
class Highlight(models.Model):
    user = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)
    selection = models.OneToOneField(TextSelection, on_delete=models.CASCADE)
    color = models.CharField(max_length=100, null=True, blank=True)

    annotation = models.TextField(max_length=1000, null=True, blank=True)  

    def __str__(self):
        return self.text