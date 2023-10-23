from rest_framework import serializers
from rest_framework import status
from rest_framework.exceptions import APIException
from .models import *


class TextSelectionSerializer(serializers.ModelSerializer):
    chapterId = serializers.PrimaryKeyRelatedField(many=False, read_only=True, source='chapter')
    offsetEnd = serializers.IntegerField(source='offset_end')
    class Meta:
        model = TextSelection
        fields = "__all__"

class WriterFeedbackSerializer(serializers.ModelSerializer):
    selection = TextSelectionSerializer(many=False)
    userId = serializers.PrimaryKeyRelatedField(many=False, read_only=True, source='user')
    chapterId = serializers.PrimaryKeyRelatedField(many=False, read_only=True, source='selection.chapter')
    isSuggestion = serializers.BooleanField(source='suggestion')
    parentId = serializers.PrimaryKeyRelatedField(many=False, read_only=True, source='parent')
    sentiment = serializers.CharField(source='get_sentiment_display')
    class Meta:
        model = WriterFeedback
        exclude = ['user', 'parent', 'suggestion']
    
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