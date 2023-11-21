from django.contrib import admin
from .models import (
    Book,
    Chapter,
    NarrativeElementType,
    NarrativeElementAttributeType,
    NarrativeElement,
    NarrativeElementAttribute,
)


# Register your models here.
@admin.register(Book)
class BookAdmin(admin.ModelAdmin):
    list_display = ("id", "title", "cover", "created", "modified", "user")


@admin.register(Chapter)
class ChapterAdmin(admin.ModelAdmin):
    list_display = ("book", "chapter_title", "chapter_number", "content", "raw_content")


@admin.register(NarrativeElementType)
class NarrativeElementTypeAdmin(admin.ModelAdmin):
    list_display = ("user", "name")


@admin.register(NarrativeElementAttributeType)
class NarrativeElementAttributeTypeAdmin(admin.ModelAdmin):
    list_display = ("user", "name", "applicable_to")


@admin.register(NarrativeElement)
class NarrativeElementAdmin(admin.ModelAdmin):
    list_display = (
        "book",
        "user",
        "name",
        "description",
        "image",
        "element_type",
        "chapter",
    )


@admin.register(NarrativeElementAttribute)
class NarrativeElementAttributeAdmin(admin.ModelAdmin):
    list_display = ("element", "attribute_type", "attribute")
