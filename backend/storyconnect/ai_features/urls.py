from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *


app_name = "ai_features"

router = DefaultRouter()
router.register(r"narrative_elements", NarrativeElementViewset)

urlpatterns = [
    path("api/", include(router.urls)),
    path('api/request/', RoadUnblockerRequestView.as_view(), name="roadunblocker_request"),
    path('api/suggestion/', RoadUnblockerSuggestionView.as_view(), name="roadunblocker_suggestion"),
    path('api/narrative_elements/generate/<int:book_id>/', NarrativeElementGen.as_view(), name="narrative_element_gen"),
    path('api/continuities/<int:chapter_id>/', ContinuityCheckerView.as_view(), name="continuity")

]