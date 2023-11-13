from rest_framework import serializers
from .models import Book, Chapter, Library, NarrativeElement, NarrativeElementType, NarrativeElementAttribute, NarrativeElementAttributeType

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
        exclude = ['reader']


class NarrativeElementSerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    class Meta:
        model = NarrativeElement
        fields = "__all__"

class NarrativeElementTypeSerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    class Meta:
        model = NarrativeElementType
        fields = "__all__"
    
class NarrativeElementAttributeSerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    class Meta:
        model = NarrativeElementAttribute
        fields = "__all__"

class NarrativeElementAttributeTypeSerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    class Meta:
        model = NarrativeElementAttributeType
        fields = "__all__"