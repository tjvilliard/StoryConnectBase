from django.urls import path
from features import views as features_view

app_name = "features"

urlpatterns = [    
    path('api/genretagging/<int:book_id>/', features_view.GenreTaggingAPIView.as_view(), name="genretagging"),
    path('api/chaptertagging/<int:book_id>/<int:chapter_num>/', features_view.ChapterTaggingAPIView.as_view(), name="chaptertagging")
]