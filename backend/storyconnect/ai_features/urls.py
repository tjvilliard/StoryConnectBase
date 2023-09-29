from django.urls import path, include
from .views import RoadUnblockerRequestView, RoadUnblockerSuggestionView


app_name = "ai_features"

urlpatterns = [
    path('request/', RoadUnblockerRequestView.as_view(), name="roadunblocker_request"),
    path('suggestion/', RoadUnblockerSuggestionView.as_view(), name="roadunblocker_suggestion"),
]