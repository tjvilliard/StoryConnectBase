from rest_framework import serializers
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


class LibrarySerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    # reader = serializers.PrimaryKeyRelatedField(queryset=User.objects.all(), many=False)
    class Meta:
        model = Library
        fields = "__all__"
