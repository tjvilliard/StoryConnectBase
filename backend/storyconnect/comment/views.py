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



class CommentViewSet(viewsets.GenericViewSet, CreateModelMixinJson, ListModelMixinJson, RetrieveModelMixinJson, UpdateModelMixinJson):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    @action(detail=True, methods=['post'])
    def dismiss(self, request, pk=None):
        comment = self.get_object()
        comment.dismissed = True
        comment.save()
        return Response(status=status.HTTP_200_OK)

class AnnotationViewSet(viewsets.GenericViewSet, CreateModelMixinJson, ListModelMixinJson, RetrieveModelMixinJson, UpdateModelMixinJson, DestroyModelMixinJson):
    queryset = Annotation.objects.all()
    serializer_class = AnnotationSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

class HighlightViewSet(viewsets.ModelViewSet, CreateModelMixinJson, ListModelMixinJson, RetrieveModelMixinJson, UpdateModelMixinJson, DestroyModelMixinJson ):
    queryset = Highlight.objects.all()
    serializer_class = HighlightSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]    