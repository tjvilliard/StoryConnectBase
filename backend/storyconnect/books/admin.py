from django.contrib import admin
from .models import (
    Book,
    Chapter,
    NarrativeElementType,
    NarrativeElementAttributeType,
    NarrativeElement,
    NarrativeElementAttribute,
)


admin.site.register(Book)
admin.site.register(Chapter)
admin.site.register(NarrativeElementType)
admin.site.register(NarrativeElementAttributeType)
admin.site.register(NarrativeElement)
admin.site.register(NarrativeElementAttribute)
