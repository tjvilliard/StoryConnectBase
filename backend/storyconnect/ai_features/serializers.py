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


# class GptCompletionSerializer(serializers.Serializer):
#     id = serializers.CharField()
#     object = serializers.CharField()
#     created = serializers.IntegerField()
#     model = serializers.CharField()
#     choices = serializers.ListField(child=serializers.DictField())
#     usage = serializers.DictField()