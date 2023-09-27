from json import JSONDecodeError
from django.http import JsonResponse
from django.shortcuts import render, redirect
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated, IsAuthenticatedOrReadOnly
from rest_framework import viewsets, status, filters
from rest_framework.response import Response
from rest_framework.decorators import action
from storyconnect.mixins import *
from .models import *
from .serializers import *
from django.db import transaction



class WriterFeedbackViewSet(viewsets.GenericViewSet, CreateModelMixinJson, ListModelMixinJson, RetrieveModelMixinJson, UpdateModelMixinJson):
    queryset = WriterFeedback.objects.all()
    serializer_class = WriterFeedbackSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    @action(detail=True, methods=['post'])
    def dismiss(self, request, pk=None):
        '''
        Dismisses the comment. This is done by setting the dismissed field to true.
        '''
        comment = self.get_object()
        comment.dismissed = True
        comment.save()
        return Response(status=status.HTTP_200_OK)
    @action(detail=False, methods=['get'])
    def by_chapter(self, request):
        chapter_id = request.query_params.get('chapter')
        comments = WriterFeedback.objects.filter(selection__chapter__id=chapter_id)
        serializer = WriterFeedbackSerializer(comments, many=True)
        return Response(serializer.data)

class HighlightViewSet(viewsets.ModelViewSet, CreateModelMixinJson, ListModelMixinJson, RetrieveModelMixinJson, UpdateModelMixinJson, DestroyModelMixinJson ):
    queryset = Highlight.objects.all()
    serializer_class = HighlightSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]    