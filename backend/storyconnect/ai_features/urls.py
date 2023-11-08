from django.urls import path
from .views import RoadUnblockerRequestView, RoadUnblockerSuggestionView, NarrativeElementView, ContinuityCheckerView


app_name = "ai_features"

urlpatterns = [
    path('api/request/', RoadUnblockerRequestView.as_view(), name="roadunblocker_request"),
    path('api/suggestion/', RoadUnblockerSuggestionView.as_view(), name="roadunblocker_suggestion"),
    path('api/narrative_elements/<int:book_id>/', NarrativeElementView.as_view(), name="narrative_element"),
    path('api/continuities/<int:chapter_id>/', ContinuityCheckerView.as_view(), name="continuity")

]