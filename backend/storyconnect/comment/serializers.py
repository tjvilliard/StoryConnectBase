from rest_framework import serializers
from rest_framework import status
from rest_framework.exceptions import APIException
from .models import *




class TextSelectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = TextSelection
        fields = "__all__"

class CommentSerializer(serializers.ModelSerializer):
    selection = TextSelectionSerializer(many=False)
    class Meta:
        model = Comment
        fields = "__all__"
    
    def create(self, validated_data):
        selection_data = validated_data.pop('selection')
        selection = TextSelection.objects.create(**selection_data)
        comment = Comment.objects.create(selection=selection, **validated_data)
        return comment

class AnnotationSerializer(serializers.ModelSerializer):
    selection = TextSelectionSerializer(many=False)
    class Meta:
        model = Annotation
        fields = "__all__"
    
    def create(self, validated_data):
        selection_data = validated_data.pop('selection')
        selection = TextSelection.objects.create(**selection_data)
        annotation = Annotation.objects.create(selection=selection, **validated_data)
        return annotation

class HighlightSerializer(serializers.ModelSerializer):
    selection = TextSelectionSerializer(many=False)
    class Meta:
        model = Highlight
        fields = "__all__"  

    def create(self, validated_data):
        selection_data = validated_data.pop('selection')
        selection = TextSelection.objects.create(**selection_data)
        highlight = Highlight.objects.create(selection=selection, **validated_data)
        return highlight