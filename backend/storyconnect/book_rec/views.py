from rest_framework.response import Response
from rest_framework import viewsets, status, filters
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.decorators import action
from books.models import *
from book_rec import models as bookrec_models
from book_rec import serializers as bookrec_serializers

# # Create your views here.
    
class Book_Based_Rec_APIView(APIView):
    serializer_class = bookrec_serializers.Book_Based_Rec_Serializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    queryset = bookrec_models.Book_Based_Rec.objects.all().prefetch_related("book")
    
    @action(detail=True, methods=["get"])
    def get(self, request, *args, **kwargs):
        bb_rec = self.queryset.filter(book__id = kwargs.get('book_id'))
        serializer=bookrec_serializers.Book_Based_Rec_Serializer(bb_rec, many=True)
        return Response(serializer.data)

class User_Based_Rec_APIView(APIView):
    serializer_class = bookrec_serializers.User_Based_Rec_Serializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    queryset = bookrec_models.User_Based_Rec.objects.all().prefetch_related("user")
    
    @action(detail=True, methods=["get"])
    def get(self, request, *args, **kwargs):
        ub_rec = self.queryset.filter(user__id = kwargs.get('user_id'))
        serializer=bookrec_serializers.User_Based_Rec_Serializer(ub_rec, many=True)
        return Response(serializer.data)

class Book_Rating_APIView(APIView):
    serializer_class = bookrec_serializers.Book_Rating_Serializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    queryset = bookrec_models.Book_Rating.objects.all().prefetch_related("book")
    
    @action(detail=True, methods=["get"])
    def get(self, request, *args, **kwargs):
        book_rating = self.queryset.filter(book__id = kwargs.get('book_id'))
        serializer=bookrec_serializers.Book_Rating_Serializer(book_rating, many=True)
        return Response(serializer.data)