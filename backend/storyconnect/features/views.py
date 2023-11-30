from django.http import JsonResponse
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.views import APIView
from books import models as book_models
from features import models as features_models
from features import serializers as features_serializers

class GenreTaggingAPIView(APIView):
    serializer_class = features_serializers.GenreTaggingSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    queryset = features_models.GenreTagging.objects.all().prefetch_related("book")
    
    @action(detail=True, methods=["get"])
    def get(self, request, *args, **kwargs):
        genretags = self.queryset.filter(book__id = kwargs.get('book_id'))
        serializer=features_serializers.GenreTaggingSerializer(genretags, many=True)
        return Response(serializer.data)

class ChapterTaggingAPIView(APIView):
    serializer_class = features_serializers.ChapterTaggingSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    queryset = features_models.ChapterTagging.objects.all().prefetch_related("chapter")
    
    @action(detail=True, methods=["get"])
    def get(self, request, *args, **kwargs):
        genretags = self.queryset.filter(book__id = kwargs.get('book_id'))
        serializer=features_serializers.GenreTaggingSerializer(genretags, many=True)
        return Response(serializer.data)