from django.db import models
from django.contrib.auth.models import User
from books.models import Chapter



class CommentManager(models.Manager):
    '''
    Custom manager for the Comment model.
    '''

    def all_exclude_ghost(self, chapter_pk=None):
        '''
        Returns all comments that are not floating. If chapter_pk is provided, only comments from that chapter are returned.
        '''
        if chapter_pk is None:
            return self.filter(selection__floating = False)
        
        return self.filter(selection__chapter__id=chapter_pk, selection__floating = False)
        
    
    def all_exclude_dismissed(self, chapter_pk=None):
        '''
        Returns all comments that are not dismissed.
        '''
        if chapter_pk is None:
            return self.filter(dismissed=False)
        
        return self.filter(selection__chapter__id=chapter_pk, dismissed=False)
    
    def all_active(self, chapter_pk=None):
        '''
        Returns all comments and suggestions that are not dismissed and not floating
        '''
        if chapter_pk is None:
            return self.filter(dismissed = False, selection__floating = False)
        
        return self.filter(selection__chapter__id=chapter_pk, dismissed = False, selection__floating = False)
    
    def all_suggestions(self, active=True, chapter_pk=None):
        '''
        Returns all suggestions. If active is true, only suggestions that are not dismissed and not floating are returned.
        '''
        if chapter_pk is None:
            if active:
                return self.filter(dismissed=False, selection__floating=False).exclude(suggestion__isnull=True)
            else:
                return self.exclude(suggestion__isnull=True)
            
        if active:
            return self.filter(chapter__id = chapter_pk, dismissed=False, selection__floating=False).exclude(suggestion__isnull=True)
        else:
            self.filter(chapter__id = chapter_pk).exclude(suggestion__isnull=True)
    
    def all_comments(self, active = True, chapter_pk=None):
        '''
        Returns all comments. If active is true, only comments that are not dismissed and not floating are returned.
        '''
        if chapter_pk is None:
            if active:
                return self.filter(suggestion__isnull = True, dismissed=False, selection__floating=False)
            else:
                return self.filter(suggestion__isnull = True)
        
        if active:
            return self.filter(chapter__id = chapter_pk, suggestion_isnull=True, dismissed=False, selection__floating=False)
        else:
            return self.filter(chapter__id = chapter_pk, suggestion__isnull=True)