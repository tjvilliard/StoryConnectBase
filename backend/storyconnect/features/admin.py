from django.contrib import admin
from .models import Review, GenreTagging, ChapterTagging

admin.site.register(Review)
admin.site.register(GenreTagging)
admin.site.register(ChapterTagging)