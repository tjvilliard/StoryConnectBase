from rest_framework import serializers
from features.models import Review, GenreTagging, ChapterTagging

class GenreTaggingSerializer(serializers.ModelSerializer):
    class Meta:
        model = GenreTagging
        # fields = "__all__"
        exclude = ('book', 'id')

class ChapterTaggingSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChapterTagging
        fields = "__all__"

class ReviewSerializer(serializers.ModelSerializer):
    class Meta:
        model = Review
        fields = "__all__"