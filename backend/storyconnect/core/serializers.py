from rest_framework import serializers
from .models import Profile, Activity, Announcement

class UserUidConversionSerializer(serializers.Serializer):
    username = serializers.CharField()


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = "__all__"


class ActivitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Activity
        fields = "__all__"
        extra_kwargs = {'user': {'required': False, 'allow_null': True}}

class AnnouncementSerializer(serializers.ModelSerializer):
    class Meta:
        model = Announcement
        fields = "__all__"
        extra_kwargs = {'user': {'required': False, 'allow_null': True}}