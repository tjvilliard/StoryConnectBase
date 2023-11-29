from rest_framework import serializers
from features.models import Review, GenreTag, ChapterTagging

class GenreTagSerializer(serializers.ModelSerializer):
    class Meta:
        model = GenreTag
        fields = "__all__"

class ChapterTaggingSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChapterTagging
        fields = "__all__"

class ReviewSerializer(serializers.ModelSerializer):
    class Meta:
        model = Review
        fields = "__all__"