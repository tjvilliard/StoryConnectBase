from rest_framework import serializers
from .models import Book, Chapter, Character, Location

class BookSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields = ['id', 'title', 'author', 'cover', 'synopsis', 'date_created', 'date_modified', 'owner']

class ChapterSerializer(serializers.ModelSerializer):
    class Meta:
        model = Chapter
        fields = ['id', 'book', 'title', 'content']

class CharacterSerializer(serializers.ModelSerializer):
    class Meta:
        model = Character
        fields = ['id', 'book', 'name', 'description', 'image']

class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ['id', 'book', 'name', 'description']
