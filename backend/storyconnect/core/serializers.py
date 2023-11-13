from rest_framework import serializers
from .models import Profile, Activity, Announcement
from django.contrib.auth.models import User

class UserUidConversionSerializer(serializers.Serializer):
    username = serializers.CharField()


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = "__all__"


class ActivitySerializer(serializers.ModelSerializer):
    user = serializers.IntegerField(read_only=True, required=False)

    class Meta:
        model = Activity
        fields = "__all__"
        extra_kwargs = {'user': {'required': False, 'allow_null': True}}

class AnnouncementSerializer(serializers.ModelSerializer):
    user = serializers.IntegerField(read_only=True, required=False)

    class Meta:
        model = Announcement
        fields = "__all__"
        extra_kwargs = {'user': {'required': False, 'allow_null': True}}