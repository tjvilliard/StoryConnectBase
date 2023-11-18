from django.db import models
from django.contrib.auth.models import User


class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    bio = models.CharField(max_length=255)
    display_name = models.CharField(
        max_length=255,
        unique=True,
    )
    image_url = models.TextField(null=True, blank=True)

    def __str__(self):
        return self.display_name

    @property
    def uid(self) -> str:
        return self.user.username


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
