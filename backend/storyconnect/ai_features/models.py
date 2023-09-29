from django.db import models
from books.models import Chapter
from comment.models import TextSelection
# Create your models here.

class RoadUnblockerSuggestion(models.Model):
    '''Model that holds suggestion data generated using LLM.'''

    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE, related_name='road_unblocker_suggestions')

    suggestion = models.TextField(blank=True, null=True)

    suggestion_type = models.CharField(max_length=50, blank=True, null=True)

