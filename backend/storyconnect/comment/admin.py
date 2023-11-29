from django.contrib import admin
from .models import WriterFeedback, Highlight, TextSelection
# Register your models here.

admin.site.register(WriterFeedback)
admin.site.register(Highlight)
admin.site.register(TextSelection)