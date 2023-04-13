# from rest_framework import serializers
from rest_framework_json_api import serializers 
from rest_framework import status
from rest_framework.exceptions import APIException
from .models import *

class BookSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields = ('id', 'title', 'author', 'cover', 'synopsis', 'date_created', 'date_modified', 'owner')
        read_only_fields = ('id',)

class ChapterSerializer(serializers.ModelSerializer):
    class Meta:
        model = Chapter
        fields = ('id', 'book', 'title', 'content')
        read_only_fields = ('id',)

class CharacterSerializer(serializers.ModelSerializer):
    class Meta:
        model = Character
        fields = ('id', 'book', 'name', 'description', 'image')
        read_only_fields = ('id',)

class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ('id', 'book', 'name', 'description')
        read_only_fields = ('id',)
