from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    ProfileViewSet,
    UserUidConversion,
    ActivityViewSet,
    AnnouncementViewSet,
    ProfileDisplayNameVerification,
    ProfileImageUpload,
    GetProfileByDisplayName,
    CatalystViewSet
)

app_name = "core"

router = DefaultRouter()
router.register(r"profiles", ProfileViewSet)
router.register(r"activities", ActivityViewSet)
router.register(r"announcements", AnnouncementViewSet)
router.register(r"makeUser", CatalystViewSet)

urlpatterns = [
    path("api/", include(router.urls)),
    path(
        "api/display_name/<int:id>/",
        UserUidConversion.as_view(),
        name="user_uid_conversion_request",
    ),
    path(
        "api/display_name/verify_uniqueness/",
        ProfileDisplayNameVerification.as_view(),
        name="profile_display_name_verification",
    ),
    path(
        "api/profile/image_upload/",
        ProfileImageUpload.as_view(),
        name="profile_image_upload",
    ),
    path(
        "api/username/by_display_name/<str:display_name>/",
        GetProfileByDisplayName.as_view(),
        name="get_username_by_display"
    ),
]
