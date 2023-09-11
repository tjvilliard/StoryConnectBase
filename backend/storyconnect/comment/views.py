from json import JSONDecodeError
from django.http import JsonResponse
from django.shortcuts import render, redirect
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework import viewsets, status, filters
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.mixins import ListModelMixin,UpdateModelMixin,RetrieveModelMixin
from .models import *
from .serializers import *
from django.db import transaction

class CommentViewSet(viewsets.ModelViewSet):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer

class AnnotationViewSet(viewsets.ModelViewSet):
    queryset = Annotation.objects.all()
    serializer_class = AnnotationSerializer

class HighlightViewSet(viewsets.ModelViewSet):
    queryset = Highlight.objects.all()
    serializer_class = HighlightSerializer    