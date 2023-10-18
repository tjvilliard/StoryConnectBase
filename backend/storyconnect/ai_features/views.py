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
from models import StatementSheet
from .continuity_checker import ContinuityChecker
from books import models as books_models
from serializers import *

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

class ContinuityChecker(APIView):
    
    def post(self, request, format=None):
        cc = ContinuityChecker()

        book = request.query_params.get('book')
        ch_num = request.query_params.get('chapter') # chapter number

        s_sheet = StatementSheet.objects.filter(book=book).first()

        if s_sheet is None:
            text = books_models.Chapter.objects.filter(book=book, chapter_number=0).content
            document = cc.create_statementsheet(text)
            StatementSheet.object.create(book=book, document=document, last_run_chapter = 0, last_run_offset = len(text))
            return Response(status=status.HTTP_200_OK)
        
        # Make a document for the new text and compare 

        # Chapter = last run chapter
        
        if ch_num == s_sheet.last_run_chapter:
            chapter_offset = s_sheet.last_run_offset
            return continuity_checker_helper(book, ch_num, s_sheet, chapter_offset, cc)
        else:
            ch_curr = books_models.Chapter.objects.filter(book=book, chapter_number=ch_num).first()
            s_sheet.last_run_chapter = ch_num
            s_sheet.last_run_offset = len(ch_curr.content)
            return continuity_checker_helper(book, ch_num, s_sheet, 0, cc)


# Helper function for ContinuityChecker -- should i put this inside the class? or will that fuck with the api view? 
def continuity_checker_helper(book, chapter, statementsheet, offset, cc):
    new_text = books_models.Chapter.objects.filter(book=book, chapter_number=chapter).content[offset:]
    new_sheet = cc.create_statementsheet(new_text)
    comparison = cc.compare_statementsheets(statementsheet.document, new_sheet)

    if comparison == 'NONE':
        data = {'message': "Everything looks good. Greate job!",
                'contradictions': []}
    else:
        data = {'message': "It looks there are some continuity errors in your story.",
                'contradictions': comparison.split('\n')}
        
    return ContinuityCheckerResponseSerializer(data=data)