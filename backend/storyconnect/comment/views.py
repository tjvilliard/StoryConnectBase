from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.decorators import action
from .models import *
from .serializers import *
from django.http import JsonResponse
from django.db import transaction
from rest_framework.mixins import CreateModelMixin, ListModelMixin, RetrieveModelMixin, UpdateModelMixin, DestroyModelMixin


class WriterFeedbackViewSet(viewsets.GenericViewSet, CreateModelMixin, ListModelMixin, RetrieveModelMixin, UpdateModelMixin):
    queryset = WriterFeedback.objects.all()
    serializer_class = WriterFeedbackSerializer
    queryset = Highlight.objects.all()
    serializer_class = HighlightSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
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
    @action(detail=True, methods=['get'])
    def by_chapter(self, request, pk=None):
        '''
        Returns all comments excluding floating. If chapter_pk is provided, only comments from that chapter are returned.
        '''
        comments = WriterFeedback.objects.all_comments(chapter_pk=pk)
        serializer = WriterFeedbackSerializer(comments, many=True)
        return JsonResponse(serializer.data)

class HighlightViewSet(viewsets.GenericViewSet, CreateModelMixin, ListModelMixin, RetrieveModelMixin, UpdateModelMixin, DestroyModelMixin):
    queryset = Highlight.objects.all()
    serializer_class = HighlightSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]    