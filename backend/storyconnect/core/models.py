from django.db import models
from django.contrib.auth.models import User
from .authentication import FirebaseAuthentication


class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    bio = models.CharField(max_length=255)
    display_name = models.CharField(max_length=255)

    def __str__(self):
        return self.display_name
    
    @property
    def uid(self):
        return self.user.username

    @property
    def display_name(self):
        return FirebaseAuthentication.get_firebase_user(self.uid).display_name
    

class Activity(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    subject = models.CharField(max_length=255)
    object = models.CharField(max_length=255)
    action = models.CharField(max_length=255)
    preposition = models.CharField(max_length=255)
    time = models.DateTimeField()


class Announcement(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)  
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True) 



