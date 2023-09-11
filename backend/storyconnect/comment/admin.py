from django.contrib import admin

# Register your models here.

@admin.register(admin.ModelAdmin)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('user', 'selection', 'comment', 'parent')

@admin.register(admin.ModelAdmin)
class AnnotationAdmin(admin.ModelAdmin):
    list_display = ('user', 'selection', 'annotation')

@admin.register(admin.ModelAdmin)
class HighlightAdmin(admin.ModelAdmin):
    list_display = ('user', 'selection', 'color')
    