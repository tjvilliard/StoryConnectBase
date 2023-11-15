
# Create your views here.
from json import JSONDecodeError
from django.http import JsonResponse
from django.shortcuts import render, redirect
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework import viewsets, status, filters
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.mixins import ListModelMixin,UpdateModelMixin,RetrieveModelMixin
from books import models as book_models
from books import serializers as book_serializers
from comment import models as comment_model
from comment import serializers as comment_serializers

class BrowserPage(APIView):

    def get(self, request):
        all_books = book_models.Book.objects.all()
        serializer = book_serializers.BookSerializer(all_books, many=True)
        return Response(serializer.data)

class LibraryPage(APIView):
    
    def get (self, request, user_id):
        user_books = book_models.Book.objects.filter(owner=user_id)
        # context = {}
        # for book in user_books:
        #     book_detail = []
        #     for detail in Book.objects.get(id=book.pk):
        #         book_title = detail.title
        #         book_cover = detail.cover
        #         book_detail.append(book_title)
        #         book_detail.append(book_cover)
        #     context[str(book.pk)] = book_detail
        serializer = book_serializers.BookSerializer(user_books, many=True)
        return Response(serializer.data)
      
class MyPage(APIView):

    def get(self,request, user_id):
        curr_read = book_models.Library.objects.filter(reader=user_id, status=1)
        user_books = book_models.Book.objects.filter(owner=user_id)
        curr_read_serializer = book_serializers.LibrarySerializer(curr_read, many=True)
        user_books_serializer = book_serializers.BookSerializer(user_books, many=True)

        content = {
            'curr_read': curr_read_serializer.data,
            'user_books': user_books_serializer.data
        }
        return JsonResponse(content)

class WriterFeedbackPage(APIView):

    def get(self,request, user_id, book_id):
        writer_books = book_models.Book.objects.filter(owner=user_id) # for the drop down
        book_feedback = book_models.Book.objects.get(id=book_id)
        chapter_feedback = book_models.Chapter.objects.filter(book=book_feedback)

        chapter_id = [ch.pk for ch in chapter_feedback]
        # comments = book_models.Comments.objects.filter(chapter__in=chapter_id)

        writer_books_serializer = book_serializers.BookSerializer(writer_books, many=True)
        book_feedback_serializer = book_serializers.BookSerializer(book_feedback, many=False)
        chapter_feedback_serializer = book_serializers.ChapterSerializer(chapter_feedback, many=True)
        # comments_serializer = book_serializers.CommentSerializer(comments, many=True)

        content = {
            'writer_books': writer_books_serializer.data,
            'book_feedback': book_feedback_serializer.data,
            'chapter_feedback': chapter_feedback_serializer.data
            # 'comments': comments_serializer.data
        }
        return JsonResponse(content)

class BookDetailPage(APIView):

    def get(self,request, book_id):
        book_details = book_models.Book.objects.get(id=book_id)
        characters = book_models.Character.objects.filter(book=book_details)

        book_details_serializer = book_serializers.BookSerializer(book_details, many=False)
        characters_serializer = book_serializers.CharacterSerializer(characters, many = True)
        content = {
            'book_details': book_details_serializer.data,
            'characters': characters_serializer.data
        }
        return JsonResponse(content)

class DemographicsPage(APIView):

    def get(self, request, user_id, book_id):
        unique_readers = book_models.Library.objects.get(id=book_id)
        chapter_comments = comment_model.WriterFeedback.objects.filter(user=user_id)
        unique_readers_serializer = book_serializers.BookSerializer(unique_readers, many=False)
        chapter_comments_serializer = comment_serializers.WriterFeedbackSerializer(chapter_comments, many=True)
        content = {
            'unique_readers': unique_readers_serializer.data,
            'chapter_comments': chapter_comments_serializer.data
        }
        return JsonResponse(content)