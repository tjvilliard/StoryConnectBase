from django.contrib import admin
from .models import (
    Book,
    Library,
    Chapter,
    Library,
    NarrativeElementType,
    NarrativeElementAttributeType,
    NarrativeElement,
    NarrativeElementAttribute,
)


admin.site.register(Book)
admin.site.register(Library)
admin.site.register(Chapter)
admin.site.register(Library)
admin.site.register(NarrativeElementType)
admin.site.register(NarrativeElementAttributeType)
admin.site.register(NarrativeElement)
admin.site.register(NarrativeElementAttribute)
