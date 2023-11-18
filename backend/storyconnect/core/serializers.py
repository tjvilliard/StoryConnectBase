from rest_framework import serializers
from .models import Profile, Activity, Announcement
from django.core.files.uploadedfile import UploadedFile


class UserUidConversionSerializer(serializers.Serializer):
    username = serializers.CharField()


class ProfileSerializer(serializers.ModelSerializer):
    profile_image_url = serializers.ImageField(required=False)

    class Meta:
        model = Profile
        fields = "__all__"

    def create(self, validated_data: dict):
        image = validated_data.pop("profile_image_url", None)
        profile = super().create(validated_data)  # type: Profile
        if image:
            profile.profile_image_url = ProfileSerializer.upload_to_firestore(
                image, profile.uid
            )
            profile.save()
        return profile

    def update(self, instance, validated_data):
        image = validated_data.pop("image", None)
        profile = super().update(instance, validated_data)  # type: Profile
        if image:
            profile.profile_image_url = ProfileSerializer.upload_to_firestore(
                image, profile.uid
            )
            profile.save()
        return profile


@staticmethod
def upload_to_firestore(image_file: UploadedFile, firebase_uid: str):
    from firebase_admin import storage
    from django.conf import settings
    import uuid

    if not hasattr(settings, "FIREBASE_BUCKET"):
        raise Exception("FIREBASE_BUCKET not set in settings.py")

    # Determine the content type of the image
    content_type = image_file.content_type

    storage_bucket = settings.FIREBASE_BUCKET

    bucket = storage.bucket(storage_bucket)
    file_name = f"profile_images/{firebase_uid}/{uuid.uuid4()}"

    # Append appropriate file extension based on content type
    if content_type == "image/jpeg":
        file_name += ".jpg"
    elif content_type == "image/png":
        file_name += ".png"

    blob = bucket.blob(file_name)

    # Set metadata
    blob.metadata = {"contentType": content_type}

    blob.upload_from_file(image_file, content_type=content_type)
    blob.make_public()
    return blob.public_url


class ActivitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Activity
        fields = "__all__"
        extra_kwargs = {"user": {"required": False, "allow_null": True}}


class AnnouncementSerializer(serializers.ModelSerializer):
    class Meta:
        model = Announcement
        fields = "__all__"
        extra_kwargs = {"user": {"required": False, "allow_null": True}}
