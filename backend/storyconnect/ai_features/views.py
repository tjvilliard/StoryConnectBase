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
from .models import StatementSheet
from .continuity_checker import ContinuityChecker
from books import models as books_models
from .serializers import *
from uuid import uuid4

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


class NarrativeElementView(APIView): 

    def get(self,request, format=None, *args, **kwargs): 
        # Mock data for narrative elements (replace with actual data retrieval logic)
        hardcoded_narrative_elements = [{"bookId":105,"elementType":{"userId":1,"name":"Character"},"attributes":[{"elementId":1,"attribute":"Brave","attributeType":{"user_id":1,"name":"Personality","applicable_to":{"userId":1,"name":"Character"}},"confidence":0.9,"generated":True},{"elementId":2,"attribute":"Fool-hardy","attributeType":{"user_id":1,"name":"Personality","applicable_to":{"userId":1,"name":"Character"}},"confidence":0.5,"generated": True},{"elementId":1,"attribute":"Blonde Hair","attributeType":{"user_id":1,"name":"Physical Appearance","applicable_to":{"userId":1,"name":"Character"}},"confidence":0.85,"generated":True}],"userId":1,"name":"Elena","description":"Elena is a brave warrior from the northern tribes.","imageUrl":"https://example.com/images/elena.jpg","chapterId":1},{"bookId":105,"elementType":{"userId":1,"name":"Location"},"attributes":[{"elementId":2,"attribute":"Mystical","attributeType":{"user_id":1,"name":"Feature","applicable_to":{"userId":1,"name":"Location"}},"confidence":0.25,"generated":True},{"elementId":2,"attribute":"Dimly Lit","attributeType":{"user_id":1,"name":"Lighting","applicable_to":{"userId":1,"name":"Location"}},"confidence":0.92,"generated":True}],"userId":1,"name":"Whispering Woods","description":"A dense forest known for its ancient mysteries and dim lighting.","imageUrl":"https://example.com/images/whispering_woods.jpg","chapterId":1}]
        return Response(hardcoded_narrative_elements)
    
class ContinuityView(APIView): 
    def get(self,request, format=None, *args, **kwargs): 
        # Mock data for continuity (replace with actual data retrieval logic)
        hardcoded_continuities = {"message":"This is a message","items":[{"content":"This is a suggestion","uuid":"1234","chapter_id":475,"startChar": None,"suggestionType":"suggestion"},{"content":"This is a warning","uuid":"12345","chapter_id":475,"startChar":None,"suggestionType":"warning"},{"content":"This is an error","uuid":"12346","chapter_id":475,"startChar":None,"suggestionType":"error"}]}
        return Response(hardcoded_continuities)


class NarrativeElementView(APIView): 

    def get(self,request, format=None, *args, **kwargs): 
        # Mock data for narrative elements (replace with actual data retrieval logic)
        hardcoded_narrative_elements = [{"bookId":105,"elementType":{"userId":1,"name":"Character"},"attributes":[{"elementId":1,"attribute":"Brave","attributeType":{"user_id":1,"name":"Personality","applicable_to":{"userId":1,"name":"Character"}},"confidence":0.9,"generated":True},{"elementId":2,"attribute":"Fool-hardy","attributeType":{"user_id":1,"name":"Personality","applicable_to":{"userId":1,"name":"Character"}},"confidence":0.5,"generated": True},{"elementId":1,"attribute":"Blonde Hair","attributeType":{"user_id":1,"name":"Physical Appearance","applicable_to":{"userId":1,"name":"Character"}},"confidence":0.85,"generated":True}],"userId":1,"name":"Elena","description":"Elena is a brave warrior from the northern tribes.","imageUrl":"https://example.com/images/elena.jpg","chapterId":1},{"bookId":105,"elementType":{"userId":1,"name":"Location"},"attributes":[{"elementId":2,"attribute":"Mystical","attributeType":{"user_id":1,"name":"Feature","applicable_to":{"userId":1,"name":"Location"}},"confidence":0.25,"generated":True},{"elementId":2,"attribute":"Dimly Lit","attributeType":{"user_id":1,"name":"Lighting","applicable_to":{"userId":1,"name":"Location"}},"confidence":0.92,"generated":True}],"userId":1,"name":"Whispering Woods","description":"A dense forest known for its ancient mysteries and dim lighting.","imageUrl":"https://example.com/images/whispering_woods.jpg","chapterId":1}]
        return Response(hardcoded_narrative_elements)
    
class ContinuityView(APIView): 
    def get(self,request, format=None, *args, **kwargs): 
        # Mock data for continuity (replace with actual data retrieval logic)
        hardcoded_continuities = {"message":"This is a message","items":[{"content":"This is a suggestion","uuid":"1234","chapter_id":475,"startChar": None,"suggestionType":"suggestion"},{"content":"This is a warning","uuid":"12345","chapter_id":475,"startChar":None,"suggestionType":"warning"},{"content":"This is an error","uuid":"12346","chapter_id":475,"startChar":None,"suggestionType":"error"}]}
        return Response(hardcoded_continuities)

class ContinuityCheckerView(APIView):
    
    # def post(self, request, format=None):
    #     cc = ContinuityChecker()

    #     book = request.query_params.get('book')
    #     ch_num = request.query_params.get('chapter') # chapter id

    #     s_sheet = StatementSheet.objects.filter(book=book).first()

    #     if s_sheet is None:
    #         text = books_models.Chapter.objects.filter(book=book, chapter_number=0).content
    #         document = cc.create_statementsheet(text)
    #         StatementSheet.object.create(book=book, document=document, last_run_chapter = 0, last_run_offset = len(text))
    #         return Response(status=status.HTTP_200_OK)
        
    #     # Make a document for the new text and compare 

    #     # Chapter = last run chapter
        
    #     if ch_num == s_sheet.last_run_chapter:
    #         chapter_offset = s_sheet.last_run_offset
    #         return continuity_checker_helper(book, ch_num, s_sheet, chapter_offset, cc)
    #     else:
    #         ch_curr = books_models.Chapter.objects.filter(book=book, chapter_number=ch_num).first()
    #         s_sheet.last_run_chapter = ch_num
    #         s_sheet.last_run_offset = len(ch_curr.content)
    #         return continuity_checker_helper(book, ch_num, s_sheet, 0, cc)
    
    def get(self, request, *args, **kwargs):
        cc = ContinuityChecker()

        ch_id = kwargs.get('id') # chapter id
        chapter = books_models.Chapter.objects.get(id=ch_id)
        ch_num = chapter.chapter_number

        book = chapter.book


        s_sheet = StatementSheet.objects.filter(book=book).first()

        if s_sheet is None:
            text = chapter.content
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
        response_data = {
            'message': "Everything looks good. Greate job!",
            'contradictions': []}
    else:
        items = None
        for item in comparison.split('\n'):
            items.append({'content': item, 'chapterId': chapter, 'uuid': uuid4()})

        response_data = {
            'message': "It looks there are some continuity errors in your story.",
            'contradictions': items}
    
    serializer = ContinuityCheckerResponseSerializer(response_data)
    return Response(serializer.data, status=status.HTTP_200_OK)