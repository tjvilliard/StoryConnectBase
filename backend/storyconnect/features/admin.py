from django.contrib import admin
from .models import Review, GenreTag, ChapterTagging

admin.site.register(Review)
admin.site.register(GenreTag)
admin.site.register(ChapterTagging)