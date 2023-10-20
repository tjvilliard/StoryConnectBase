from django.contrib import admin
from .models import StatementSheet

# Register your models here.
@admin.register(StatementSheet)
class StatementSheetAdmin(admin.ModelAdmin):
    list_display = ('book', 'last_run_chapter', 'last_run_offset', 'last_run_response', 'document')
