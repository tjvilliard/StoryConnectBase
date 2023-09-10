from rest_framework import serializers
from rest_framework import status
from rest_framework.exceptions import APIException
from .models import *

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = "__all__"

class TextSelectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = TextSelection
        fields = "__all__"

class AnnotationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Annotation
        fields = "__all__"