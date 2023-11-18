from rest_framework import serializers


class RoadUnblockerRequestSerializer(serializers.Serializer):
    chapter_id = serializers.IntegerField()
    selection = serializers.CharField(allow_blank=True, allow_null=True)
    question = serializers.CharField()

class RoadUnblockerSuggestionSerializer(serializers.Serializer):
    uid = serializers.CharField()
    offset_start = serializers.IntegerField()
    offset_end = serializers.IntegerField()
    suggestion = serializers.CharField()
    original = serializers.CharField(required=False)
    suggested_change = serializers.CharField()

class RoadUnblockerResponseSerializer(serializers.Serializer):
    uid = serializers.CharField()
    suggestions = RoadUnblockerSuggestionSerializer(many=True)
    message = serializers.CharField()

class ContinuityItemSerializer(serializers.Serializer):
    uid = serializers.CharField()
    content = serializers.CharField()
    chapter_id = serializers.IntegerField()
    


class ContinuityCheckerResponseSerializer(serializers.Serializer):
    # contradictions = serializers.ListField(child=ContinuityItemSerializer())
    # items = serializers.ListField(child=ContinuityItemSerializer(), allow_empty=True)
    items = ContinuityItemSerializer(many=True, allow_empty=True)
    message = serializers.CharField()

