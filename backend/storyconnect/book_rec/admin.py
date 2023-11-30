from django.contrib import admin
from .models import Book_Based_Rec, Book_Rating, User_Based_Rec

admin.site.register(Book_Based_Rec)
admin.site.register(Book_Rating)
admin.site.register(User_Based_Rec)