from django.contrib import admin
from .models import Activity, Announcement, Profile

# Register your models here.


@admin.register(Activity)
class ActivityAdmin(admin.ModelAdmin):
    list_display = ("user", "subject", "object", "action", "preposition", "time")


@admin.register(Announcement)
class AnnouncementAdmin(admin.ModelAdmin):
    list_display = ("user", "title", "content", "created_at")


@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):
    list_display = ("user", "bio", "display_name", "profile_image_url")
