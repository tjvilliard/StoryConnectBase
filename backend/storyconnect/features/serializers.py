from rest_framework import serializers
from rest_framework import status
from rest_framework.exceptions import APIException
from features.models import *

class GenreTaggingSerializer(serializers.ModelSerializer):
    class Meta:
        model = GenreTagging
        fields = "__all__"

class ChapterTaggingSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChapterTagging
        fields = "__all__"