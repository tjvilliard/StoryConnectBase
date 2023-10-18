from django.urls import path, include
from .views import *


app_name = "ai_features"

urlpatterns = [
    path('ru_request/', RoadUnblockerRequestView.as_view(), name="roadunblocker_request"),
    path('ru_suggestion/', RoadUnblockerSuggestionView.as_view(), name="roadunblocker_suggestion"),
    path('continuity_checker/(?P<id>.+)/$', ContinuityCheckerView.as_view(), name="continuity_checker"),
]