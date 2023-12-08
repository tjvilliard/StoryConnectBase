from rest_framework.response import Response
from rest_framework import viewsets, status, filters
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.decorators import action
from books.models import *
from books import serializers as books_serializers
from book_rec import models as bookrec_models
from book_rec import serializers as bookrec_serializers

# # Create your views here.
import pandas as pd

# class Book_Based_Rec_APIView(APIView):
#     serializer_class = bookrec_serializers.Book_Based_Rec_Serializer
#     permission_classes = [IsAuthenticatedOrReadOnly]
#     queryset = bookrec_models.Book_Based_Rec.objects.all().prefetch_related("book")
    
#     @action(detail=True, methods=["get"])
#     serializer_class = bookrec_serializers.Book_Based_Rec_Serializer
#     permission_classes = [IsAuthenticatedOrReadOnly]
#     queryset = bookrec_models.Book_Based_Rec.objects.all().prefetch_related("book")
    
#     @action(detail=True, methods=["get"])
#     def get(self, request, *args, **kwargs):
#         bb_rec = self.queryset.filter(book__id = kwargs.get('book_id'))
#         serializer=bookrec_serializers.Book_Based_Rec_Serializer(bb_rec, many=True)
#         bb_rec = self.queryset.filter(book__id = kwargs.get('book_id'))
#         serializer=bookrec_serializers.Book_Based_Rec_Serializer(bb_rec, many=True)
#         return Response(serializer.data)

class User_Based_Rec_APIView(APIView):
    serializer_class = books_serializers.BookSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    queryset = Book.objects.all().prefetch_related("user")
    
    @action(detail=True, methods=["get"])
    def get(self, request, *args, **kwargs):
        bookrec_dataset = pd.read_csv('book_rec/bookrec_data.csv', index_col=0)
        libSet = Library.objects.filter(reader = request.user)

        bookSet = []

        for lib in libSet:
            bookSet.append(Book.objects.filter(id = lib.book))

        bookRec = []

        for book in bookSet:
            my_value = book.pk
            bookrecs_of_the_book = bookrec_dataset.loc[bookrec_dataset["id"] == my_value]
            bookrecs_of_the_book_id = list(bookrecs_of_the_book['rec_id'])
            bookrecs_of_the_book_book_model = Book.objects.filter(pk__in=bookrecs_of_the_book_id)
        serializer=bookrec_serializers.Book_Based_Rec_Serializer(bookrecs_of_the_book_book_model, many=True)
            # content = {'title': book, 'recommendation':bookrecs_of_the_book_book_model}

            # for each_rec in bookrecs_of_the_book_id:
            #     recbook = Book.objects.get(pk=each_rec)
            #     content = {'book':book, 'recommendation': recbook}
        return Response(serializer.data)

# class Book_Rating_APIView(APIView):
#     serializer_class = bookrec_serializers.Book_Rating_Serializer
#     permission_classes = [IsAuthenticatedOrReadOnly]
#     queryset = bookrec_models.Book_Rating.objects.all().prefetch_related("book")
    
#     @action(detail=True, methods=["get"])
#     serializer_class = bookrec_serializers.Book_Rating_Serializer
#     permission_classes = [IsAuthenticatedOrReadOnly]
#     queryset = bookrec_models.Book_Rating.objects.all().prefetch_related("book")
    
#     @action(detail=True, methods=["get"])
#     def get(self, request, *args, **kwargs):
#         book_rating = self.queryset.filter(book__id = kwargs.get('book_id'))
#         serializer=bookrec_serializers.Book_Rating_Serializer(book_rating, many=True)
#         return Response(serializer.data)