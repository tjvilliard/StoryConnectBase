"""storyconnect URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path 
from rest_framework import routers
from books import views as books_views
from comment import views as comment_views
from ai_features import urls as ai_features_urls
from ai_features import views as ai_features_views
from core import urls as core_views
from features import views as features_view
from features import urls as features_url
from book_rec import urls as bookrec_url

router = routers.DefaultRouter()
router.register(r'api/books', books_views.BookViewSet)
router.register(r'api/books-by-title', books_views.BooksByTitleViewSet)
router.register(r'api/books-by-synopsis', books_views.BooksBySynopsisViewSet)
router.register(r'api/books-by-author', books_views.BooksByAuthorViewSet)
router.register(r'api/library', books_views.LibraryViewSet)
router.register(r'api/chapters', books_views.ChapterViewSet)
router.register(r'api/highlights', comment_views.HighlightViewSet)
router.register(r'api/feedback', comment_views.WriterFeedbackViewSet)

#router.register(r'api/genretagging', features_view.GenreTaggingAPIView)

urlpatterns = router.urls

urlpatterns += [
    # path('api/road_unblock/', ai_features.RoadUnblockerRequestView.as_view()),
    
    path('api/admin/', admin.site.urls),
    path('api/road_unblock/', ai_features_views.RoadUnblockerRequestView.as_view()),
    path('api/genretagging/<int:book_id>/', features_view.GenreTaggingAPIView.as_view(), name="genretagging"),
    path('api/chaptertagging/<int:book_id>/<int:chapter_num>/', features_view.ChapterTaggingAPIView.as_view(), name="chaptertagging"),
]

urlpatterns += ai_features_urls.urlpatterns
urlpatterns += core_views.urlpatterns
# urlpatterns += features_url.urlpatterns
urlpatterns += bookrec_url.urlpatterns