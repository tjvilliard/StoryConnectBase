from django.contrib import admin
from .models import WriterFeedback, Highlight, TextSelection
# Register your models here.

@admin.register(TextSelection)
class TextSelectionAdmin(admin.ModelAdmin):
    list_display = ('chapter', 'offset', 'offset_end', 'text', 'floating')
    
@admin.register(WriterFeedback)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('user', 'selection', 'comment', 'parent')

@admin.register(Highlight)
class HighlightAdmin(admin.ModelAdmin):
    list_display = ('user', 'selection', 'color')
    