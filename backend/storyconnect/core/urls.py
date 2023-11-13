from django.urls import path
from .views import UserUidConversion


app_name = "core"

urlpatterns = [
    path('api/display_name/<str:uid>/', UserUidConversion.as_view(), name="user_uid_conversion_request"),
]