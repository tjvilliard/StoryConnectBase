from django.contrib import admin
from .models import *

# Register your models here.
@admin.register(StatementSheet)
class StatementSheetAdmin(admin.ModelAdmin):
    list_display = ('book', 'last_run_chapter', 'last_run_offset', 'last_run_response', 'document')

@admin.register(ChapterSummary)
class ChapterSummaryAdmin(admin.ModelAdmin):
    list_display = ('chapter', 'summary')

@admin.register(BookSummary)
class BookSummaryAdmin(admin.ModelAdmin):
    list_display = ('book', 'summary', 'last_sum_chapter')