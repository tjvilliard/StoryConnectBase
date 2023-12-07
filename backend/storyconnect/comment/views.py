from django.http import JsonResponse
from rest_framework.permissions import  IsAuthenticatedOrReadOnly
from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.decorators import action
from storyconnect.mixins import CreateModelMixinJson, CreateModelWithUserMixinJson, ListModelMixinJson, RetrieveModelMixinJson, UpdateModelMixinJson, DestroyModelMixinJson
from .models import WriterFeedback, Highlight
from .serializers import WriterFeedbackSerializer, HighlightSerializer
import logging

from django.db import transaction

class WriterFeedbackViewSet(viewsets.GenericViewSet, CreateModelWithUserMixinJson, ListModelMixinJson, RetrieveModelMixinJson, UpdateModelMixinJson):
    queryset = WriterFeedback.objects.all()
    serializer_class = WriterFeedbackSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    logger = logging.getLogger(__name__)

    @action(detail=True, methods=['post']) #consider changing the action of this to put rather than post.
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
    
    @action(detail=False, methods=['get'])
    def get_comments_include_ghost(self, request, pk=None):
        '''
        Returns all comments including floating. If chapter_pk is provided, only comments from that chapter are returned.
        '''
        comments = WriterFeedback.objects.all_comments(include_ghost=True, chapter_pk=pk)
        serializer = WriterFeedbackSerializer(comments, many=True)
        return JsonResponse(serializer.data)
    
    @action(detail=False, methods=['get'])
    def get_comments_exclude_ghost(self, request, pk=None):
        '''
        Returns all comments excluding floating. If chapter_pk is provided, only comments from that chapter are returned.
        '''
        comments = WriterFeedback.objects.all_comments(chapter_pk=pk)
        serializer = WriterFeedbackSerializer(comments, many=True)
        return JsonResponse(serializer.data)
    
    @action(detail=False, methods=['get'])
    def get_suggestions_include_ghost(self, request, pk=None):
        ''' 
        Returns all suggestions including floating. If chapter_pk is provided, only comments from that chapter are returned.
        '''
        comments = WriterFeedback.objects.all_suggestions(include_ghost=True, chapter_pk=pk)
        serializer = WriterFeedbackSerializer(comments, many=True)
        return JsonResponse(serializer.data)
    
    @action(detail=False, methods=['get'])
    def get_suggestions_exclude_ghost(self, request, pk=None):
        '''
        Returns all suggestions excluding floating. If chapter_pk is provided, only comments from that chapter are returned.
        '''
        comments = WriterFeedback.objects.all_suggestions(chapter_pk=pk)
        serializer = WriterFeedbackSerializer(comments, many=True)
        return JsonResponse(serializer.data)



class HighlightViewSet(viewsets.ModelViewSet, CreateModelMixinJson, ListModelMixinJson, RetrieveModelMixinJson, UpdateModelMixinJson, DestroyModelMixinJson ):
    queryset = Highlight.objects.all()
    serializer_class = HighlightSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]    