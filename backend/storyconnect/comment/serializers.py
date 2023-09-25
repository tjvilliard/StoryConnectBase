from rest_framework import serializers
from rest_framework import status
from rest_framework.exceptions import APIException
from .models import *


class TextSelectionSerializer(serializers.ModelSerializer):
    chapter = serializers.PrimaryKeyRelatedField(many=False, read_only=True)
    class Meta:
        model = TextSelection
        fields = "__all__"

class WriterFeedbackSerializer(serializers.ModelSerializer):
    selection = TextSelectionSerializer(many=False)
    class Meta:
        model = WriterFeedback
        fields = "__all__"
    
    def create(self, validated_data):
        selection_data = validated_data.pop('selection')
        selection = TextSelection.objects.create(**selection_data)
        comment = WriterFeedback.objects.create(selection=selection, **validated_data)
        return comment


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