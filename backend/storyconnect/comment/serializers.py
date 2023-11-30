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
    sentiment = serializers.IntegerField()

    class Meta:
        model = WriterFeedback
        exclude = ['user', 'parent', 'suggestion']

    def get_sentiment(self, obj):
        print(f"[INFO] getting Sentiment display: {obj}")
        return obj.get_sentiment_display()

    def create(self, validated_data):
        print('')
        print(f"[INFO] ${validated_data}")
        selection_data = validated_data.pop('selection')
        selection = TextSelection.objects.create(**selection_data)
        print(f"[INFO] ${validated_data}")
        comment = WriterFeedback.objects.create(selection=selection, **validated_data)
        print(f"[INFO] ${comment.__str__}")
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