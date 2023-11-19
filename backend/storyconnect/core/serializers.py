import io
from rest_framework import serializers
from .models import Profile, Activity, Announcement
import base64


class UserUidConversionSerializer(serializers.Serializer):
    username = serializers.CharField()


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = "__all__"


class ProfileImageSerializer(serializers.Serializer):
    image = serializers.CharField()  # base64 encoded image


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


class ImageUploader:
    @staticmethod
    def get_content_type(image_data: bytes) -> str:
        """Determine the content type of the image based on its byte signature."""
        if image_data[:3] == b"\xff\xd8\xff":
            return "image/jpeg"
        elif image_data[:8] == b"\x89PNG\r\n\x1a\n":
            return "image/png"
        else:
            raise ValueError("Unsupported image format")

    @staticmethod
    def upload_to_firestore(raw_image_file: str, firebase_uid: str):
        from django.conf import settings
        import uuid

        if not hasattr(settings, "FIREBASE_BUCKET"):
            raise Exception("FIREBASE_BUCKET not set in settings.py")
        # Decode the base64 string
        image_data = base64.b64decode(raw_image_file)

        # Wrap the bytes data in a BytesIO object
        image_stream = io.BytesIO(image_data)

        # Determine the content type of the image
        content_type = ImageUploader.get_content_type(image_data)

        # Create a reference to the Firebase storage bucket
        storage_bucket = settings.FIREBASE_BUCKET

        # Create a unique file name
        file_extension = ".jpg" if content_type == "image/jpeg" else ".png"
        file_name = f"profile_images/{firebase_uid}/{uuid.uuid4()}{file_extension}"

        # Create a blob for the image
        blob = storage_bucket.blob(file_name)

        # Upload the image data
        blob.upload_from_file(image_stream, content_type=content_type)

        # Make the image publicly accessible
        blob.make_public()

        return blob.public_url
