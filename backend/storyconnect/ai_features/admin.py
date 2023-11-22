from django.contrib import admin
from ai_features.models import (
    StatementSheet,
    BookSummary,
    ChapterSummary,
    RoadUnblockerSuggestion,



)

admin.site.register(StatementSheet)
admin.site.register(BookSummary)
admin.site.register(ChapterSummary)
admin.site.register(RoadUnblockerSuggestion)
