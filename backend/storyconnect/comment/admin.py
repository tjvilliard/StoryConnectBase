from django.contrib import admin
from .models import Comment, Annotation, Highlight, TextSelection
# Register your models here.

@admin.register(TextSelection)
class TextSelectionAdmin(admin.ModelAdmin):
    list_display = ('chapter', 'offset', 'length', 'text', 'floatng')
    
@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('user', 'selection', 'comment', 'parent')

@admin.register(Annotation)
class AnnotationAdmin(admin.ModelAdmin):
    list_display = ('user', 'selection', 'annotation')

@admin.register(Highlight)
class HighlightAdmin(admin.ModelAdmin):
    list_display = ('user', 'selection', 'color')
    