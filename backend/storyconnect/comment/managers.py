from django.db import models
from django.contrib.auth.models import User
from books.models import Chapter



class WriterFeedbackManager(models.Manager):
    '''
    Custom manager for the Comment model.
    '''

    def all_exclude_ghost(self, chapter_pk=None):
        '''
        Returns all comments and suggestions that are not floating. If chapter_pk is provided, only comments from that chapter are returned.
        '''
        if chapter_pk is None:
            return self.filter(selection__floating = False)
        
        return self.filter(selection__chapter__id=chapter_pk, selection__floating = False)
        
    
    def all_exclude_dismissed(self, chapter_pk=None):
        '''
        Returns all comments and suggestions that are not dismissed.
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
    
    def all_suggestions(self, include_dismissed=False, include_ghost=False, chapter_pk=None):
        '''
        Returns all suggestions. If active is true, only suggestions that are not dismissed and not floating are returned.
        '''
        if chapter_pk is None:
            
            all_comments = self.filter(suggestion=True)

            if not include_dismissed:
                all_comments = all_comments.filter(dismissed=False)
            if not include_ghost:
                all_comments = all_comments.filter(selection__floating=False)
        else:
            all_comments = self.filter(suggestion=True, chapter__id=chapter_pk)

            if not include_dismissed:
                all_comments = all_comments.filter(dismissed=False)
            if not include_ghost:
                all_comments = all_comments.filter(selection__floating=False)
        
        return all_comments
    
    def all_comments(self, include_dismissed=False, include_ghost=False, chapter_pk=None):
        '''
        Returns all comments. If active is true, only comments that are not dismissed and not floating are returned.
        '''

        
        if chapter_pk is None:
            
            all_comments = self.filter(suggestion=False)

            if not include_dismissed:
                all_comments = all_comments.filter(dismissed=False)
            if not include_ghost:
                all_comments = all_comments.filter(selection__floating=False)
        else:
            all_comments = self.filter(suggestion=False, selection__chapter__id=chapter_pk)

            if not include_dismissed:
                all_comments = all_comments.filter(dismissed=False)
            if not include_ghost:
                all_comments = all_comments.filter(selection__floating=False)
            
        return all_comments