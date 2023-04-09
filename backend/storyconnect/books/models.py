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
    title = models.CharField(max_length=100)
    author = models.CharField(max_length=100)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    cover = models.ImageField(upload_to='covers/')
    date_created = models.DateTimeField(auto_now_add=True)
    date_modified = models.DateTimeField(auto_now=True)
    synopsis = models.TextField(max_length=1000)
    tagging = models.CharField(max_length=30)

    def __str__(self):
        return self.title
    
class Library(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    status = models.CharField(max_length=1)

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
    bookcover = models.ImageField(upload_to='covers/') #?
    
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
    bookID = models.ForeignKey(Book, on_delete=models.CASCADE)
    libID = models.ForeignKey(Library, on_delete=models.CASCADE)