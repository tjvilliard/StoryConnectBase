from django.urls import path, include
from .views import RoadUnblockerRequestView, RoadUnblockerSuggestionView, NarrativeElementView, ContinuityView


app_name = "ai_features"

urlpatterns = [
    path('api/request/', RoadUnblockerRequestView.as_view(), name="roadunblocker_request"),
    path('api/suggestion/', RoadUnblockerSuggestionView.as_view(), name="roadunblocker_suggestion"),
    path('api/narrative_elements/<int:book_id>/', NarrativeElementView.as_view(), name="narrative_element"),
    path('api/continuities/<int:chapter_id>/', ContinuityView.as_view(), name="continuity")

]