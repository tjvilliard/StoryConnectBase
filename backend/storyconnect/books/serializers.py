from rest_framework import serializers
# from rest_framework_json_api import serializers 
from rest_framework import status
from rest_framework.exceptions import APIException
from .models import *

class BookSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields = "__all__"

class ChapterSerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    class Meta:
        model = Chapter
        fields = "__all__"

class CharacterSerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    class Meta:
        model = Character
        fields = "__all__"

class LocationSerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    class Meta:
        model = Location
        fields = "__all__"

class LibrarySerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    # reader = serializers.PrimaryKeyRelatedField(queryset=User.objects.all(), many=False)
    class Meta:
        model = Library
        fields = "__all__"

class SceneSerializer(serializers.ModelSerializer):
    # chapter = serializers.PrimaryKeyRelatedField(queryset=Chapter.objects.all(), many=False)
    class Meta:
        model = Scene
        fields = "__all__"

# class CommentSerializer(serializers.ModelSerializer):
#     book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
#     chapter = serializers.PrimaryKeyRelatedField(queryset=Chapter.objects.all(), many=False)
#     class Meta:
#         model = Comments
#         fields = "__all__"