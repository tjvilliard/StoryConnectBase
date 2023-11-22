from rest_framework.response import Response
from rest_framework import viewsets, status, filters
from rest_framework.views import APIView
from books.models import *
from book_rec import models as bookrec_models
from book_rec import serializers as bookrec_serializers

# # Create your views here.

class Book_Based_Rec_APIView(APIView):

    def get(self, request, *args, **kwargs):
        book_id = request.query_params.get('book_id')
        intended_book = Book.objects.get(pk = book_id)
        the_book_based_rec = bookrec_models.Book_Based_Rec.objects.get(book=intended_book)
        serializer = bookrec_serializers.Book_Based_Rec_Serializer(the_book_based_rec, many=False)

        return Response(serializer.data)

class User_Based_Rec_APIView(APIView):

    def get(self, request, *args, **kwargs):
        user_id = request.query_params.get('user_id')
        intended_user = User.objects.get(pk = user_id)
        the_user_based_rec = bookrec_models.Book_Based_Rec.objects.get(user=intended_user)
        serializer = bookrec_serializers.Book_Based_Rec_Serializer(the_user_based_rec, many=False)

        return Response(serializer.data)

class Book_Rating_APIView(APIView):

    def get(self, request, *args, **kwargs):
        book_id = request.query_params.get('book_id')
        intended_book = Book.objects.get(pk = book_id)
        the_book_rating = bookrec_models.Book_Rating.objects.get(book=intended_book)
        serializer = bookrec_serializers.Book_Based_Rec_Serializer(the_book_rating, many=False)

        return Response(serializer.data)