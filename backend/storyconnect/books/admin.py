from django.contrib import admin
from .models import *

# Register your models here.
@admin.register(Book)
class BookAdmin(admin.ModelAdmin):
    list_display = ('title', 'author', 'cover', 'synopsis', 'date_created', 'date_modified', 'owner')

@admin.register(Chapter)
class ChapterAdmin(admin.ModelAdmin):   
    list_display = ('book', 'title', 'content')

@admin.register(Character)
class CharacterAdmin(admin.ModelAdmin):
    list_display = ('book', 'name', 'description', 'image')

@admin.register(Location)
class LocationAdmin(admin.ModelAdmin):
    list_display = ('book', 'name', 'description')  