from django.db import models
from django.contrib.auth.models import User
from books.models import Chapter



class CommentManager(models.Manager):

    def all_exclude_ghost(self):
        return self.filter(is_ghost=False)
    
    def all_exclude_dismissed(self):
        return self.filter(dismissed=False)
    
    def all_active(self):
        return self.filter(dismissed=False, ghost=False)
    
    def all_suggestions(self, active=True):
        if active:
            return self.filter(is_suggestion=True, dismissed=False, ghost=False)
        else:
            self.filter(is_suggestion=True)
    
    def all_comments(self, active=True):
        if active:
            return self.filter(is_suggestion=False, dismissed=False, ghost=False)
        else:
            return self.filter(is_suggestion=False)