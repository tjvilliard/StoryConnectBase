from django.db import models
from django.contrib.auth.models import User


# Create your models here.

class Book(models.Model):
    # LANGUAGES = [
    #     (1, "English"),
    #     (2, "Indonesian")
    # ]
    TARGET_AUDIENCES = [
        (1, "Young Adult (13-18 years old)"), 
        (2, "New Adult (18-25 years old)"),
        (3, "Adult (25+ years old)")
    ]
    # taken from chapterly.com and wattpad.com
    COPYRIGHTS = [
        (1, "All Rights Reserved: No part of this publication may be reproduced, stored or transmitted in any form or by any means, electronic, mechanical, photocopying, recording, scanning, or otherwise without written permission from the publisher. It is illegal to copy this book, post it to a website, or distribute it by any other means without permission."), 
        (2, "Public Domain: This story is open source for the public to use for any purposes."), 
        (3, "Creative Commons (CC) Attribution: Author of the story has some rights to some extent and allow the public to use this story for purposes like translations or adaptations credited back to the author.")
    ]
    
    title = models.CharField(max_length=100)
    author = models.CharField(max_length=100)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    language = models.CharField(max_length=20)
    target_audience = models.IntegerField(choices=TARGET_AUDIENCES)
    # target_audience = models.TextChoices("Young Adult (13-18 years old)", "New Adult (18-25 years old)", "Adult (25+ years old)")
    cover = models.ImageField(upload_to='covers/', blank=True)
    date_created = models.DateTimeField(auto_now_add=True)
    date_modified = models.DateTimeField(auto_now=True)
    synopsis = models.TextField(max_length=1000)
    # tagging = models.CharField(max_length=30)
    # copyright = models.TextChoices("All Rights Reserved: No part of this publication may be reproduced, stored or transmitted in any form or by any means, electronic, mechanical, photocopying, recording, scanning, or otherwise without written permission from the publisher. It is illegal to copy this book, post it to a website, or distribute it by any other means without permission.", 
        # "Public Domain: This story is open source for the public to use for any purposes.", 
        # "Creative Commons (CC) Attribution: Author of the story has some rights to some extent and allow the public to use this story for purposes like translations or adaptations credited back to the author.")
    copyright = models.IntegerField(choices=COPYRIGHTS)
    titlepage = models.TextField()

    def __str__(self):
        return self.title
    
    def get_chapters(self):
        return Chapter.objects.filter(book=self)
    
    def get_locations(self):
        return Location.objects.filter(book=self)
    
    def get_characters(self):
        return Character.objects.filter(book=self)
    
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

    # redundant?
    chapter_title = models.CharField(max_length=100) 

    chapter_content = models.TextField()

    # What are these for?
    # scene = models.CharField(max_length=50, blank=True)
    # scene_content = models.CharField(max_length=50, blank=True)

    def __str__(self):
        return self.chapter_title
    
    def get_scenes(self):
        return Scene.objects.filter(chapter=self)
    
    

class Character(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    name = models.CharField(max_length=100, blank=True)
    nickname = models.CharField(max_length=100, blank=True)

    # Whats the difference between bio and description?
    bio = models.CharField(max_length=50, blank=True)
    description = models.TextField(blank=True)

    image = models.ImageField(upload_to='characters/', blank=True)
    attributes = models.CharField(max_length=200, blank=True)

    # add more fields here

    def __str__(self):
        return self.name

class Location(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    name = models.CharField(max_length=100, blank=True)
    description = models.TextField(blank=True)

    # add more fields here

    def __str__(self):
        return self.name

class Scene(models.Model):
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
    scene_title = models.CharField(max_length=100, blank=True)
    scene_content = models.TextField(blank=True)

    def __str__(self):
        return self.scene_title
