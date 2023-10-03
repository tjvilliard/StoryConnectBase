from django.db import models
# from django import forms
from django.contrib.auth.models import User
from django_extensions.db.models import TimeStampedModel
from firebase_admin import storage
from storyconnect.settings import FIREBASE_BUCKET
import os
from django.contrib.postgres.fields import ArrayField
from django.core.validators import MaxValueValidator, MinValueValidator

# Create your models here.

class Book(models.Model):
    # LANGUAGES = [
    #     (1, "English"),
    #     (2, "Indonesian")
    # ]
    TARGET_AUDIENCES = [
        (0, "Children "), 
        (1, "Young Adult"),
        (2, "Adult (18+)")
    ]
    # taken from chapterly.com and wattpad.com
    COPYRIGHTS = [
        (0, "All Rights Reserved: No part of this publication may be reproduced, stored or transmitted in any form or by any means, electronic, mechanical, photocopying, recording, scanning, or otherwise without written permission from the publisher. It is illegal to copy this book, post it to a website, or distribute it by any other means without permission."), 
        (1, "Public Domain: This story is open source for the public to use for any purposes."), 
        (2, "Creative Commons (CC) Attribution: Author of the story has some rights to some extent and allow the public to use this story for purposes like translations or adaptations credited back to the author.")
    ]

    STATUS = [
        (1, "Complete"),
        (2, "In progress")
    ]
    
    title = models.CharField(max_length=100)
    author = models.CharField(max_length=100, null = True, blank = True)
    owner = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)
    language = models.CharField(max_length=20, null=True, blank=True)
    target_audience = models.IntegerField(choices=TARGET_AUDIENCES, null=True, blank=True)
    book_status = models.IntegerField(choices=STATUS, null=True, default=2)
    tags = ArrayField(models.CharField(max_length=50), blank=True, null=True)
    cover = models.ImageField(upload_to='covers/', null=True, blank=True)
    created = models.DateTimeField(auto_now_add=True)
    modified = models.DateTimeField(auto_now=True)
    synopsis = models.TextField(max_length=1000, null=True, blank=True)
    copyright = models.IntegerField(choices=COPYRIGHTS, null=True, blank=True)
    titlepage = models.TextField(null=True, blank=True)
    # rating = models.FloatField(null=True, blank=True, max_value = 5.0)


    cover = models.ImageField(upload_to='covers/', null=True, blank=True)

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        if self.cover:
            # uses local covers/ temporarily for image upload to bucket
            image_path = str(self.cover)
            bucket = FIREBASE_BUCKET
            blob = bucket.blob(image_path)
            blob.upload_from_filename(self.cover.path)

            # delete local covers/ after upload
            os.remove(image_path)

            # make the image public and save the public url to the image field
            blob.make_public()
            self.cover = blob.public_url  # Save the public URL to the image field
            super().save(*args, **kwargs)

    def __str__(self):
        return self.title
    
    # What does this do?
    def get_attribute(self, attr):
        if attr == "title":
            return Book.objects.filter(title=self.title)
        elif attr == "author":
            return Book.objects.filter(author=self.author)
        elif attr == "language":
            return Book.objects.filter(author=self.language)
        
    def get_chapters(self):
        return Chapter.objects.filter(book=self)
    
    def get_narrative_elements(self):
        return NarrativeElement.objects.filter(book=self)
    
    
class Library(models.Model):
    BOOK_STATUS = [
        (1, "Reading"), 
        (2, "Archived")
    ]
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    status = models.IntegerField(choices=BOOK_STATUS)
    reader = models.ForeignKey(User, on_delete=models.CASCADE)

class Chapter(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    chapter_number = models.IntegerField(default=0)
    chapter_title = models.CharField(max_length=100,blank=True) 
    content = models.TextField(blank=True)

    def save(self, *args, **kwargs):
        if not self.pk:  # check if the instance is not yet saved to the database
            last_chapter = Chapter.objects.filter(book=self.book).order_by('-chapter_number').first()
            if last_chapter:
                self.chapter_number = last_chapter.chapter_number + 1

            if self.chapter_title == "":
                self.chapter_title = f"Chapter {self.chapter_number}"
        super().save(*args, **kwargs)

    # What are these for?
    # scene = models.CharField(max_length=50, blank=True)
    # scene_content = models.CharField(max_length=50, blank=True)

    def __str__(self):
        return f'{self.book.title}: {self.chapter_number}'
    
    # def get_scenes(self):
    #     return Scene.objects.filter(chapter=self)

    
# class Character(models.Model):
#     book = models.ForeignKey(Book, on_delete=models.CASCADE)
#     name = models.CharField(max_length=100, blank=True)
#     nickname = models.CharField(max_length=100, blank=True)
#     description = models.TextField(blank=True)
#     image = models.ImageField(upload_to='characters/', blank=True)
#     def __str__(self):
#         return self.name
    
#     @property
#     def attributes(self):
#         return CharacterAttributes.objects.filter(character=self)

# class CharacterAttributes(models.Model):
#     ATTRIBUTE_TYPES = [
#         (0, "Physical"),
#         (1, "Personality"),
#         (2, "Background")
#     ]
#     character = models.ForeignKey(Character, on_delete=models.CASCADE)
#     attribute = models.CharField(max_length=100, blank=True)
#     confidence = models.IntegerField(default=0, validators=[MinValueValidator(0), MaxValueValidator(100)])
#     type = models.IntegerField(choices=ATTRIBUTE_TYPES, null=True, blank=True)
#     generated = models.BooleanField(default=False)

#     def __str__(self):
#         return self.attribute

# class Location(models.Model):
#     book = models.ForeignKey(Book, on_delete=models.CASCADE)
#     name = models.CharField(max_length=100, blank=True)
#     description = models.TextField(blank=True)
#     image = models.ImageField(upload_to='locations/', blank=True)

#     @property
#     def attributes(self):
#         return LocationAttributes.objects.filter(location=self)

#     def __str__(self):
#         return self.name

# class LocationAttributes(models.Model):
#     ATTRIBUTE_TYPES = [
#         (0, "Re-occurring"),
#         (1, "Temporary"),
#     ]
#     location = models.ForeignKey(Location, on_delete=models.CASCADE)
#     attribute = models.CharField(max_length=100, blank=True)
#     confidence = models.IntegerField(default=0, validators=[MinValueValidator(0), MaxValueValidator(100)])
#     type = models.IntegerField(choices=ATTRIBUTE_TYPES, null=True, blank=True)
#     generated = models.BooleanField(default=False)

#     def __str__(self):
#         return self.attribute


# User
#   |
#   |---< NarrativeElementType   (One User can have many NarrativeElementTypes)
#   |       |
#   |       |---< NarrativeElementAttributeType (One NarrativeElementType can be applicable to many NarrativeElementAttributeTypes)
#   |       |       |
#   |       |       |---< NarrativeElementAttributes (One NarrativeElementAttributeType can be associated with many NarrativeElementAttributes)
#   |
#   |---< NarrativeElement       (One User can have many NarrativeElements)
#           |
#           |---< Book            (One Book can be associated with many NarrativeElements)
#           |
#           |---< Chapter         (One Chapter can be associated with many NarrativeElements)
#           |
#           |---< NarrativeElementType (NarrativeElement has one NarrativeElementType)
#           |
#           |---< NarrativeElementAttributes (One NarrativeElement can have many NarrativeElementAttributes)





class NarrativeElementType(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)  # Link each NarrativeElementType to a user
    name = models.CharField(max_length=50)

    def __str__(self):
        return self.name

class NarrativeElement(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100, blank=True)
    description = models.TextField(default="",)
    image = models.ImageField(upload_to='elements/', blank=True)
    element_type = models.ForeignKey(NarrativeElementType, on_delete=models.CASCADE)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE, null=True, blank=True)

    def __str__(self):
        return self.name
    
    @property
    def attributes(self):
        return NarrativeElementAttribute.objects.filter(element=self)

class NarrativeElementAttributeType(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    applicable_to = models.ForeignKey(NarrativeElementType, on_delete=models.CASCADE)

    def __str__(self):
        return self.name

class NarrativeElementAttribute(models.Model):
    element = models.ForeignKey(NarrativeElement, on_delete=models.CASCADE)
    attribute = models.CharField(max_length=100, blank=True)
    attribute_type = models.ForeignKey(NarrativeElementAttributeType, on_delete=models.CASCADE)
    confidence = models.IntegerField(default=0, validators=[MinValueValidator(0), MaxValueValidator(100)])
    generated = models.BooleanField(default=False)

    def __str__(self):
        return self.attribute
