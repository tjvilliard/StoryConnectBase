from json import JSONDecodeError
from django.http import JsonResponse
from django.shortcuts import render, redirect
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework import viewsets, status, filters
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.mixins import ListModelMixin,UpdateModelMixin,RetrieveModelMixin
from .models import *
from .serializers import *


# Create your views here.

class BookViewSet(viewsets.ModelViewSet):
    filter_backends = (filters.SearchFilter)
    search_fields = ['title', 'author', 'language']
    queryset = Book.objects.all()
    serializer_class = BookSerializer
    #permission_classes = [IsAuthenticated]

    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return JsonResponse(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    # def perform_create(self, serializer):
    #     serializer.save(owner=self.request.user)

    # @action(detail=False, methods=['get'])
    # def list(self, request, *args, **kwargs):
    #     queryset = self.filter_queryset(self.get_queryset())

    #     page = self.paginate_queryset(queryset)
    #     if page is not None:
    #         serializer = self.get_serializer(page, many=True)
    #         return self.get_paginated_response(serializer.data)

    #     serializer = self.get_serializer(queryset, many=True)
    #     return Response(serializer.data)
    
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
    
    @action(detail=True, methods=['get'])
    def get_chapters(self, request, pk=None):
        book = self.get_object()
        chapters = book.get_chapters()
        serializer = ChapterSerializer(chapters, many=True)
        return Response(serializer.data)
    

    @action(detail=False, methods=['get'])
    def filter(self, request, filter, *args, **kwargs):
        # filter_query = Book.objects.filter()
        # data = BookSerializer(filter_query, many=False)
        # # book = self.filter_queryset(filter)
        # model_data = Book.objects.all().order_by("?")

        # book = self.get_object()
        # serializer = self.get_serializer(book, data=request.data)
        # serializer.is_valid(raise_exception=True)
        # self.filter_queryset(filter)
        # serializer = self.get_serializer(data=request.data)
        return self.filter_backends.get_search_fields(BookViewSet, request)

class ChapterViewSet(viewsets.ModelViewSet):
    queryset = Chapter.objects.all()
    serializer_class = ChapterSerializer
    #permission_classes = [IsAuthenticated]

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
    #permission_classes = [IsAuthenticated]

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
    #permission_classes = [IsAuthenticated]

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
    #permission_classes = [IsAuthenticated]

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

def browser_page(request):
    all_books = {'all_books': Book.objects.all()}
    return JsonResponse(all_books)

def library_page(request, user_id):
    user_books = Book.objects.filter(owner=user_id)
    context = {}
    for book in user_books:
        book_detail = []
        for detail in Book.objects.get(id=book.pk):
            book_title = detail.title
            book_cover = detail.cover
            book_detail.append(book_title)
            book_detail.append(book_cover)
        context[book.pk] = book_detail
    return JsonResponse(context) 

def my_page(request, user_id):
    curr_read = Library.objects.filter(reader=user_id, status=1)
    user_books = Book.objects.filter(owner=user_id)
    content = {
        'curr_read': curr_read,
        'user_books': user_books
    }
    # to set up goals, should I make a new models for user's data analytics?
    return JsonResponse(content)

def writer_feedback(request, user_id,book_id):
    writer_books = Book.objects.filter(owner=user_id) # for the drop down
    book_feedback = Book.objects.get(id=book_id)
    chapter_feedback = Chapter.objects.filter(book=book_feedback)
    comments = Comments.objects.filter(chapter=chapter_feedback)
    content = {
        'writer_books': writer_books,
        'book_feedback': book_feedback,
        'chapter_feedback': chapter_feedback,
        'comments': comments
    }
    return JsonResponse(content)

def book_detail_page(request, book_id):
    book_details = Book.objects.get(id=book_id)
    characters = Character.objects.filter(book=book_id)
    content = {
        'book_details': book_details,
        'characters': characters
    }
    return JsonResponse(content)

# def create_book(request):
#     if request.method == 'POST':
#         title = request.POST['title']
#         author = request.POST['author']
#         user = request.user  # get the currently logged-in user
#         book = Book(title=title, author=author, content=content, user=user)
#         book.save()
#         return redirect('writer_page', book_id=book.id) # would i redirect to the writer page? 
#     else:
#         return render(request, 'create_book.html')

# def create_chapter(request): # would i need to pass in the book id here?
#     if request.method == 'POST':
#         title = request.POST['title']
#         content = request.POST['content']
#         book = request.POST['book']
#         chapter = Chapter(title=title, content=content, book=book)
#         chapter.save()
#     return render(request, 'books/create_chapter.html')

# def create_character(request):
#     if request.method == 'POST':
#         name = request.POST['name']
#         description = request.POST['description']
#         book = request.POST['book']
#         character = Character(name=name, description=description, book=book)
#         character.save()
#     return render(request, 'books/create_character.html')

# def create_location(request):
#     if request.method == 'POST':
#         name = request.POST['name']
#         description = request.POST['description']
#         book = request.POST['book']
#         location = Location(name=name, description=description, book=book)
#         location.save()
#     return render(request, 'books/create_location.html')

