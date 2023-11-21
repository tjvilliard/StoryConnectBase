from django.contrib import admin
from features.models import *
# Register your models here.
@admin.register(Review)
class Review(admin.ModelAdmin):
    list_display = ('book', 'commenter', 'content', 'rating')

@admin.register(ChapterTagging)
class ChapterTagging(admin.ModelAdmin):
    list_display = ('chapter','last_chapter_len', 'genre')

@admin.register(GenreTagging)
class GenreTagging(admin.ModelAdmin):
    list_display = ('book','genre')