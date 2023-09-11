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
from rest_framework.authtoken.views import obtain_auth_token
from books import views as books_views
from comment import views as comment_views


router = routers.DefaultRouter()
router.register(r'api/books', books_views.BookViewSet)
router.register(r'api/chapters', books_views.ChapterViewSet)
router.register(r'api/highlights', comment_views.HighlightViewSet)
router.register(r'api/annotations', comment_views.AnnotationViewSet)
router.register(r'api/comments', comment_views.CommentViewSet)


urlpatterns = router.urls

urlpatterns += [
    path('api/admin/', admin.site.urls),
]
