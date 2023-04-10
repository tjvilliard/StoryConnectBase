from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Account(models.Model):
    username = models.CharField(max_length=100)
    email = models.EmailField(max_length=254)
    DOB = models.DateField()
    
    def __str__(self):
        return self.username

class Book(models.Model):
    LANGUAGES = [
        (1, "English"),
        (2, "Indonesian")
    ]
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
    language = models.TextChoices("English", "Indonesian")
    target_audience = models.CharField("Young Adult (13-18 years old)", "New Adult (18-25 years old)", "Adult (25+ years old)")
    cover = models.ImageField(upload_to='covers/')
    date_created = models.DateTimeField(auto_now_add=True)
    date_modified = models.DateTimeField(auto_now=True)
    synopsis = models.TextField(max_length=1000)
    tagging = models.CharField(max_length=30)
    copyright = models.CharField("All Rights Reserved: No part of this publication may be reproduced, stored or transmitted in any form or by any means, electronic, mechanical, photocopying, recording, scanning, or otherwise without written permission from the publisher. It is illegal to copy this book, post it to a website, or distribute it by any other means without permission.", 
        "Public Domain: This story is open source for the public to use for any purposes.", 
        "Creative Commons (CC) Attribution: Author of the story has some rights to some extent and allow the public to use this story for purposes like translations or adaptations credited back to the author.")

    def __str__(self):
        return self.title
    
class Library(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    status = models.IntegerChoices("Reading", "In the Works", "Archived")

class Chapter(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    chapter_title = models.CharField(max_length=100)
    title = models.CharField(max_length=100)
    content = models.TextField()

    def __str__(self):
        return self.chapter_title

class Manuscript_Title(models.Model):
    titlepage = models.TextField()
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    bookcover = models.ImageField(upload_to='covers/') 
    
    def __str__(self):
        return self.book.title

class Outline(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
    scene = models.CharField(max_length=50)
    scenecontent = models.CharField(max_length=50)

    def __str__(self):
        return self.chapter.chapter_title

class Character(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    nickname = models.CharField(max_length=100)
    bio = models.CharField(max_length=50)
    description = models.TextField()
    image = models.ImageField(upload_to='characters/')
    attributes = models.CharField(max_length=200)

    # add more fields here

    def __str__(self):
        return self.name

class Location(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    description = models.TextField()

    # add more fields here

    def __str__(self):
        return self.name

class General(models.Model):
    accID = models.ForeignKey(Account, on_delete=models.CASCADE)
    bookID = models.ForeignKey(Book, on_delete=models.CASCADE) # user's work(s)
    libID = models.ForeignKey(Library, on_delete=models.CASCADE)