from json import JSONDecodeError
from django.http import JsonResponse
from django.shortcuts import render, redirect
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated, IsAdminUser, AllowAny
from rest_framework import viewsets, status, filters
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.mixins import ListModelMixin,UpdateModelMixin,RetrieveModelMixin
from .models import *
from .serializers import *
from django.db import transaction
import pdb
from rest_framework.views import APIView



# Create your views here.

class BookViewSet(viewsets.ModelViewSet):
    # filter_backends = (filters.SearchFilter)
    # search_fields = ['title', 'author', 'language']
    serializer_class = BookSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    queryset = Book.objects.all()

    
    def create(self, request, *args, **kwargs):
        with transaction.atomic():
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            # add the owner 
            serializer.save(owner=request.user)
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)

            # Use the instance directly instead of querying it again
            book = serializer.instance
            # book.owner = request.user

            # print(request.user)

            # book.save()
            # Create the first chapter for the book
            Chapter.objects.create(book=book)

        # Commit the transaction
        transaction.set_autocommit(True)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    def put(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)

        return Response(serializer.data)
    
    def partial_update(self, request, *args, **kwargs):
        kwargs['partial'] = True
        return self.update(request, *args, **kwargs)
    
    @action(detail=False, methods=['get'])
    def by_writer(self, request):

        # TODO: Test this
        
        books = Book.objects.filter(owner=request.user)
        serializer = BookSerializer(books, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['get'])
    def get_chapters(self, request,pk=None):
        book = self.get_object() # type: Book
        chapters = book.get_chapters()
        
        assert len(chapters) > 0, "No chapters found for this book"
        serializer = ChapterSerializer(chapters, many=True)
        return Response(serializer.data)
    

class ChapterViewSet(viewsets.ModelViewSet):
    queryset = Chapter.objects.all()
    serializer_class = ChapterSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    def create(self, request, *args, **kwargs):
        # Assuming the book reference in your request data is named "book_id"
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        # Get the book instance
        book = serializer.validated_data['book']
        
        # Check if the owner of the book is the current user
        if book.owner != request.user:
            return Response({'detail': 'You do not have permission to create a chapter for this book.'}, status=status.HTTP_403_FORBIDDEN)

        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)


    def update(self, request, *args, **kwargs):
        instance = self.get_object() # type: Chapter
        
        # Check if the owner of the book linked to this chapter is the current user
        if instance.book.owner != request.user:
            return Response({'detail': 'You do not have permission to update this chapter.'}, status=403)

        partial = kwargs.pop('partial', False)
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data)


    def partial_update(self, request, *args, **kwargs):
        # get the book instance that we want to update
        instance = self.get_object()

        # create a serializer instance with the book instance and request data
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)

        # save the updated book instance
        self.perform_update(serializer)

        return JsonResponse(serializer.data)

# class CharacterViewSet(viewsets.ModelViewSet):
#     queryset = Character.objects.all()
#     serializer_class = CharacterSerializer
#     permission_classes = [IsAuthenticatedOrReadOnly]

#     def create(self, request, *args, **kwargs):
#         serializer = self.get_serializer(data=request.data)
#         serializer.is_valid(raise_exception=True)
#         self.perform_create(serializer)
#         headers = self.get_success_headers(serializer.data)
#         return JsonResponse(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

#     # def perform_create(self, serializer):
#     #     serializer.save(owner=self.request.user)

#     def update(self, request, *args, **kwargs):
#         partial = kwargs.pop('partial', False)
#         instance = self.get_object()
#         serializer = self.get_serializer(instance, data=request.data, partial=partial)
#         serializer.is_valid(raise_exception=True)
#         self.perform_update(serializer)
#         return JsonResponse(serializer.data)
    
# class LocationViewSet(viewsets.ModelViewSet):
#     queryset = Location.objects.all()
#     serializer_class = LocationSerializer
#     permission_classes = [IsAuthenticatedOrReadOnly]

#     def create(self, request, *args, **kwargs):
#         serializer = self.get_serializer(data=request.data)
#         serializer.is_valid(raise_exception=True)
#         self.perform_create(serializer)
#         headers = self.get_success_headers(serializer.data)
#         return JsonResponse(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

#     # def perform_create(self, serializer):
#     #     serializer.save(owner=self.request.user)

#     def update(self, request, *args, **kwargs):
#         partial = kwargs.pop('partial', False)
#         instance = self.get_object()
#         serializer = self.get_serializer(instance, data=request.data, partial=partial)
#         serializer.is_valid(raise_exception=True)
#         self.perform_update(serializer)
#         return JsonResponse(serializer.data)
    

# class SceneViewSet(viewsets.ModelViewSet):
#     queryset = Scene.objects.all()
#     serializer_class = SceneSerializer
#     permission_classes = [IsAuthenticatedOrReadOnly]

#     def create(self, request, *args, **kwargs):
#         serializer = self.get_serializer(data=request.data)
#         serializer.is_valid(raise_exception=True)
#         self.perform_create(serializer)
#         headers = self.get_success_headers(serializer.data)
#         return JsonResponse(serializer.data, status=status.HTTP_201_CREATED, headers=headers)


#     def update(self, request, *args, **kwargs):
#         partial = kwargs.pop('partial', False)
#         instance = self.get_object()
#         serializer = self.get_serializer(instance, data=request.data, partial=partial)
#         serializer.is_valid(raise_exception=True)
#         self.perform_update(serializer)
#         return JsonResponse(serializer.data)
    

class RoadUnblockerView(APIView):
    def post(self, request, format=None, *args, **kwargs):
        hardcoded_roadunblock = {
            "uid": "1234",
            "message": "Ok, got it. So it looks like you're stuck on Chapter 1. Lets take a look at what we can do:",
            "suggestions": [
                {
                    "uid": "12345",
                    "offset_start": 50,
                    "offset_end": 100,
                    "suggestion": "You could talk more about the character's motivations here.",
                    "original": "",
                    "suggested_change": "Jonathan isn't sure why he's doing this. He's just following orders."
                },
                {
                    "uid": "123456",
                    "offset_start": 150,
                    "offset_end": 200,
                    "suggestion": "It looks like you're heading to planet Earth. Perhaps your character is banned from Earth?",
                    "original": "",
                    "suggested_change": "Jonathan, although banned from Earth, needed to go home, if only to this one last time."
                },
                {
                    "uid": "1234567",
                    "offset_start": 50,
                    "offset_end": 80,
                    "suggestion": "You set your character up as a rebel, but he's not acting like one.",
                    "original": "Jonathan isn't sure why he's doing this. He's just following orders.",
                    "suggested_change": "Jonathan spits in the face of his commanding officer and defiantly says, 'Sir, yes sir'"
                }
            ]
        }
        return Response(hardcoded_roadunblock, status=status.HTTP_200_OK)
    
#TODO: Add a view for library queries

class LibraryViewSet(viewsets.ModelViewSet):
    queryset = Library.objects.all()
    serializer_class = LibrarySerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    @action(detail=False, methods=['get'])
    def get_user_library(self, request):
        library = Library.objects.filter(reader=request.user)
        serializer = LibrarySerializer(library, many=True)
        return Response(serializer.data)
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        # add the owner 
        serializer.save(reader=request.user)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
    
    @action(detail=True, methods=['post'])
    def change_entry_status(self, request):
        library = self.get_object()
        book = library.book
        book_id = book.id
        status = request.data['status']
        library.save()
        serializer = LibrarySerializer(library)
        return Response(serializer.data)
    
    @action(detail=True, methods=['delete'])
    def change_entry_status(self, request, *args, **kwargs):
        instance = self.get_object().delete()
        return Response(status=status.HTTP_204_NO_CONTENT)




#TODO: Add a view for narrative element queries
class NarrativeElementViewset:
    pass

class NarrativeElementTypeViewset:
    pass
