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
from django.urls import path, include
from rest_framework import routers
from rest_framework.authtoken.views import obtain_auth_token
import debug_toolbar
from books import views as books_views
<<<<<<< HEAD
from comment import views as comment_views

=======
from pages import views as pages_views
>>>>>>> feature/Creating_models

router = routers.DefaultRouter()
router.register(r'api/books', books_views.BookViewSet)
router.register(r'api/chapters', books_views.ChapterViewSet)
router.register(r'api/highlights', comment_views.HighlightViewSet)
router.register(r'api/feedback', comment_views.WriterFeedbackViewSet)

urlpatterns = router.urls

urlpatterns += [
    path('api/admin/', admin.site.urls),
<<<<<<< HEAD
    path("debug/", include(debug_toolbar.urls)),
=======
    path('api/browser/', pages_views.BrowserPage.as_view(), name='browser-page'),
    path('api/library/<int:user_id>/', pages_views.LibraryPage.as_view(), name='library-page'),
    path('api/account/<int:user_id>/', pages_views.MyPage.as_view(), name='my-page'),
    path('api/feedback/<int:user_id>/<int:book_id>/', pages_views.WriterFeedbackPage.as_view(), name='writer-feedback'),
    path('api/details/<int:book_id>/',pages_views.BookDetailPage.as_view(), name='book-details-page')
>>>>>>> feature/Creating_models
]
