from json import JSONDecodeError
from django.http import JsonResponse
from django.shortcuts import render, redirect
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.mixins import ListModelMixin,UpdateModelMixin,RetrieveModelMixin
from .models import *
from .serializers import *



# Create your views here.
class BookViewSet( viewsets.ModelViewSet):
    queryset = Book.objects.all()
    serializer_class = BookSerializer
    #permission_classes = [IsAuthenticated]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)

        # Create initial chapter for the book 
        Chapter.objects.create(book=serializer.instance)

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

    @action(detail=True, methods=['get'])
    def get_chapters(self, request, pk=None):
        book = self.get_object()
        chapters = book.get_chapters()
        serializer = ChapterSerializer(chapters, many=True)
        return JsonResponse(serializer.data)
    
class ChapterViewSet(viewsets.ModelViewSet):
    queryset = Chapter.objects.all()
    serializer_class = ChapterSerializer
    #permission_classes = [IsAuthenticated]

    def create(self, request, *args, **kwargs):
        try: 
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            return JsonResponse(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
        except Exception as e: 
            print(e)
            return JsonResponse({"sucess": False})

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

