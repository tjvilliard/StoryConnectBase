from json import JSONDecodeError
from django.http import JsonResponse
from django.shortcuts import render, redirect
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated, IsAuthenticatedOrReadOnly
from rest_framework import viewsets, status, filters
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.views import APIView
# Create your views here.

class RoadUblockerView(APIView):

    permission_classes = [IsAuthenticated]