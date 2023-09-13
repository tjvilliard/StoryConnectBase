from json import JSONDecodeError
from django.http import JsonResponse
from django.shortcuts import render, redirect
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated, IsAdminUser
from rest_framework import viewsets, status, filters
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.mixins import ListModelMixin,UpdateModelMixin,RetrieveModelMixin
from .models import *
from .serializers import *
from django.db import transaction
import pdb


# Create your views here.

class BookViewSet(viewsets.ModelViewSet):
    # filter_backends = (filters.SearchFilter)
    # search_fields = ['title', 'author', 'language']
    queryset = Book.objects.all()
    serializer_class = BookSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    
    def create(self, request, *args, **kwargs):
        with transaction.atomic():
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)

            # Use the instance directly instead of querying it again
            book = serializer.instance

            # Create the first chapter for the book
            Chapter.objects.create(book=book)

        # Commit the transaction
        transaction.set_autocommit(True)

        return JsonResponse(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    
    def put(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return JsonResponse(serializer.data)
    
    def partial_update(self, request, *args, **kwargs):
        kwargs['partial'] = True
        return self.update(request, *args, **kwargs)
    

    # @action(detail=True, methods=['get'])
    # def get_chapters(self, request, pk=None):
    #     book = self.get_object()
    #     chapters = book.get_chapters()

    #     if len(chapters) == 0:
    #         # Handle the case of no chapters, return an empty list
    #         return JsonResponse([], safe=False)

    #     serializer = ChapterSerializer(chapters, many=True, safe=False)
    
    #     return JsonResponse(serializer.data)

    @action(detail=True, methods=['get'])
    def get_chapters(self, request, pk=None):
        
        book = self.get_object()
        chapters = book.get_chapters()
        
        assert len(chapters) > 0, "No chapters found for this book"

        serializer = ChapterSerializer(chapters, many=True)
        
        return Response(serializer.data)
    

    # @action(detail=False, methods=['get'])
    # def filter(self, request, filter, *args, **kwargs):
    #     # filter_query = Book.objects.filter()
    #     # data = BookSerializer(filter_query, many=False)
    #     # # book = self.filter_queryset(filter)
    #     # model_data = Book.objects.all().order_by("?")

    #     # book = self.get_object()
    #     # serializer = self.get_serializer(book, data=request.data)
    #     # serializer.is_valid(raise_exception=True)
    #     # self.filter_queryset(filter)
    #     # serializer = self.get_serializer(data=request.data)
    #     return self.filter_backends.get_search_fields(BookViewSet, request)




class ChapterViewSet(viewsets.ModelViewSet):
    queryset = Chapter.objects.all()
    serializer_class = ChapterSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return JsonResponse(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    # def perform_create(self, serializer):
    #     serializer.save(owner=self.request.user)

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return JsonResponse(serializer.data)

    def partial_update(self, request, *args, **kwargs):
        # get the book instance that we want to update
        instance = self.get_object()

        # create a serializer instance with the book instance and request data
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)

        # save the updated book instance
        self.perform_update(serializer)

        return JsonResponse(serializer.data)

class CharacterViewSet(viewsets.ModelViewSet):
    queryset = Character.objects.all()
    serializer_class = CharacterSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return JsonResponse(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    # def perform_create(self, serializer):
    #     serializer.save(owner=self.request.user)

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return JsonResponse(serializer.data)
    
class LocationViewSet(viewsets.ModelViewSet):
    queryset = Location.objects.all()
    serializer_class = LocationSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return JsonResponse(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    # def perform_create(self, serializer):
    #     serializer.save(owner=self.request.user)

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return JsonResponse(serializer.data)
    

class SceneViewSet(viewsets.ModelViewSet):
    queryset = Scene.objects.all()
    serializer_class = SceneSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return JsonResponse(serializer.data, status=status.HTTP_201_CREATED, headers=headers)


    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return JsonResponse(serializer.data)
    
def writer_page(request, book_id):
    book = Book.objects.get(id=book_id)
    chapters = Chapter.objects.filter(book=book)
    characters = Character.objects.filter(book=book)
    locations = Location.objects.filter(book=book)
    context = {
        'book': book,
        'chapters': chapters,
        'characters': characters,
        'locations': locations,
    }
    return JsonResponse(context)



