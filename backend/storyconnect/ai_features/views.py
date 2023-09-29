from json import JSONDecodeError
from django.http import JsonResponse
from django.shortcuts import render, redirect
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated, IsAuthenticatedOrReadOnly
from rest_framework import viewsets, status, filters
from rest_framework.response import Response
from rest_framework.decorators import action, api_view
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .serializers import RoadUnblockerRequestSerializer, RoadUnblockerResponseSerializer, RoadUnblockerSuggestionSerializer

class RoadUnblockerRequestView(APIView):
    def post(self, request, format=None):
        
        serializer = RoadUnblockerRequestSerializer(data=request.data)
        if serializer.is_valid():
            # Mock data (replace with actual AI tool logic)
            mock_suggestions = [
                {
                    "offset_start": 12,
                    "offset_end": 30,
                    "original": "dolor sit amet",
                    "suggested_change": "sit amet consectetur"
                },
                {
                    "offset_start": 50,
                    "offset_end": 63,
                    "original": "adipiscing elit",
                    "suggested_change": "elit adipiscing"
                }
            ]
            
            
            response_data = {
                "suggestions": mock_suggestions,
                "message": "Here are some suggestions to improve your writing."
            }

            
            response_serializer = RoadUnblockerResponseSerializer(data=response_data)

            if response_serializer.is_valid():
                return Response(response_serializer.data, status=status.HTTP_200_OK)
            else:
                return Response(response_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class RoadUnblockerSuggestionView(APIView):
    def get(self, request, format=None):
        # Mock data for suggestions (replace with actual data retrieval logic)
        mock_suggestions = [
            {
                "offset_start": 12,
                "offset_end": 30,
                "original": "dolor sit amet",
                "suggested_change": "sit amet consectetur"
            },
            {
                "offset_start": 50,
                "offset_end": 63,
                "original": "adipiscing elit",
                "suggested_change": "elit adipiscing"
            }
        ]

        # Serialize the mock suggestions and return them
        serializer = RoadUnblockerSuggestionSerializer(mock_suggestions, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
