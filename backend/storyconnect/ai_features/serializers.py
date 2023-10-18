from rest_framework import serializers


class RoadUnblockerRequestSerializer(serializers.Serializer):
    chapter = serializers.IntegerField()
    selection = serializers.CharField()
    question = serializers.CharField()

class RoadUnblockerSuggestionSerializer(serializers.Serializer):
    offset_start = serializers.IntegerField()
    offset_end = serializers.IntegerField()

    suggestion = serializers.CharField()
    original = serializers.CharField(required=False)
    suggested_change = serializers.CharField()

class RoadUnblockerResponseSerializer(serializers.Serializer):
    suggestions = RoadUnblockerSuggestionSerializer(many=True)
    message = serializers.CharField()

class ContinuityItemSerializer(serializers.Serializer):
    content = serializers.CharField()


class ContinuityCheckerResponseSerializer(serializers.Serializer):
    # contradictions = serializers.ListField(child=ContinuityItemSerializer())
    contradicions = serializers.ListField(child=serializers.CharField())
    
    message = serializers.CharField()

