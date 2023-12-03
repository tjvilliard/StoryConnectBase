from rest_framework import serializers
from .models import (
    Book,
    Chapter,
    Library,
    NarrativeElement,
    NarrativeElementType,
    NarrativeElementAttribute,
    NarrativeElementAttributeType,
)


class BookSerializer(serializers.ModelSerializer):
    author_name = serializers.ReadOnlyField(required=False)

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
        exclude = ["reader"]


class LibraryBookSerializer(serializers.ModelSerializer):
    class Meta:
        model = Library
        exclude = ["reader"]
        depth = 1

class NarrativeElementTypeSerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    userId = serializers.PrimaryKeyRelatedField(many=False, read_only=True, source='user')

    class Meta:
        model = NarrativeElementType
        fields = "__all__"
class NarrativeElementAttributeTypeSerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    user_id = serializers.PrimaryKeyRelatedField(many=False, read_only=True, source='user')
    applicable_to = NarrativeElementTypeSerializer(many=False, read_only=True)
    serializers.ImageField(use_url=True)

    class Meta:
        model = NarrativeElementAttributeType
        fields = "__all__"
class NarrativeElementAttributeSerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    attributeType = NarrativeElementAttributeTypeSerializer(source="attribute_type", many=False)
    elementId = serializers.PrimaryKeyRelatedField(source="element", many=False, read_only=True)
    class Meta:
        model = NarrativeElementAttribute
        fields = "__all__"

class NarrativeElementSerializer(serializers.ModelSerializer):
    # book = serializers.PrimaryKeyRelatedField(queryset=Book.objects.all(), many=False)
    bookId = serializers.PrimaryKeyRelatedField(source="book", many=False, read_only=True)
    elementType = NarrativeElementTypeSerializer(source="element_type", many=False)
    userId = serializers.PrimaryKeyRelatedField(many=False, read_only=True, source='user')
    attributes = NarrativeElementAttributeSerializer(many=True)
    class Meta:
        model = NarrativeElement
        fields = "__all__"









