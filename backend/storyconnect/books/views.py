from django.http import JsonResponse
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import viewsets, status, filters
from rest_framework.response import Response
from rest_framework.decorators import action
from .models import Book, Chapter, Library, Profile
from .serializers import (
    BookSerializer,
    ChapterSerializer,
    LibraryBookSerializer,
    LibrarySerializer,
)
from django.db import transaction
from rest_framework.views import APIView

class BooksByTitleViewSet(viewsets.ModelViewSet):
    '''View Set for searching for a book by title.'''
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ["language", "copyright", "target_audience"]
    search_fields = ["title"]
    serializer_class = BookSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    queryset = Book.objects.all().prefetch_related("user")

class BooksBySynopsisViewSet(viewsets.ModelViewSet):
    '''View Set for searching for a book by synopsis content.'''
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ["language", "copyright", "target_audience"]
    search_fields = ["synopsis"]
    serializer_class = BookSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    queryset = Book.objects.all().prefetch_related("user")

class BooksByAuthorViewSet(viewsets.ModelViewSet):
    '''View Set for searching for a book by author name.'''
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ["language", "copyright", "target_audience"]
    serializer_class = BookSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    queryset = Book.objects.select_related("user").select_related("")

    def get_queryset(self):
        search_param = self.request.GET.get('search')
        id = list((set(Profile.objects.filter(display_name__contains=search_param).values_list('user'))))
        queryset = Book.objects.select_related("user").filter(user_id__in=id)
        return queryset

class BookViewSet(viewsets.ModelViewSet):
    #Filtering and Searching Parameters
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ["language", "copyright", "target_audience"]
    search_fields = ["title", "synopsis"]
    serializer_class = BookSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    queryset = Book.objects.all().prefetch_related("user")

    @transaction.atomic
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        # Add the owner and save the book
        serializer.save(user=request.user)
        self.perform_create(serializer)

        # Create the first chapter for the book
        book = serializer.instance
        Chapter.objects.create(book=book)

        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    def put(self, request, *args, **kwargs):
        partial = kwargs.pop("partial", False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)

        return Response(serializer.data)

    def partial_update(self, request, *args, **kwargs):
        kwargs["partial"] = True
        return self.update(request, *args, **kwargs)

    @transaction.atomic
    def destroy(self, request, *args, **kwargs):
        return super().destroy(request, *args, **kwargs)

    @action(detail=False, methods=["get"])
    def writer(self, request):
        username = request.query_params.get("username", None)

        if username:
            # Filter books based on the provided username
            books = self.queryset.filter(user__username=username)
        else:
            # Default to filtering books based on the request user
            books = self.queryset.filter(user__id=request.user.id)

        serializer = BookSerializer(books, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=["get"])
    def get_chapters(self, request, pk=None):
        book = self.get_object()  # type: Book
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
        book = serializer.validated_data["book"]

        # Check if the owner of the book is the current user
        if book.user != request.user:
            return Response(
                {
                    "detail": "You do not have permission to create a chapter for this book."
                },
                status=status.HTTP_403_FORBIDDEN,
            )

        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(
            serializer.data, status=status.HTTP_201_CREATED, headers=headers
        )

    def update(self, request, *args, **kwargs):
        instance = self.get_object()  # type: Chapter

        # Check if the owner of the book linked to this chapter is the current user
        if instance.book.owner != request.user:
            return Response(
                {"detail": "You do not have permission to update this chapter."},
                status=403,
            )

        partial = kwargs.pop("partial", False)
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

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        book = instance.book

        chapters = book.get_chapters()
        for chapter in chapters:
            if chapter.chapter_number > instance.chapter_number:
                chapter.chapter_number -= 1
                chapter.save()

        self.perform_destroy(instance)
        return Response(status=status.HTTP_200_OK)


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
                    "suggested_change": "Jonathan isn't sure why he's doing this. He's just following orders.",
                },
                {
                    "uid": "123456",
                    "offset_start": 150,
                    "offset_end": 200,
                    "suggestion": "It looks like you're heading to planet Earth. Perhaps your character is banned from Earth?",
                    "original": "",
                    "suggested_change": "Jonathan, although banned from Earth, needed to go home, if only to this one last time.",
                },
                {
                    "uid": "1234567",
                    "offset_start": 50,
                    "offset_end": 80,
                    "suggestion": "You set your character up as a rebel, but he's not acting like one.",
                    "original": "Jonathan isn't sure why he's doing this. He's just following orders.",
                    "suggested_change": "Jonathan spits in the face of his commanding officer and defiantly says, 'Sir, yes sir'",
                },
            ],
        }
        return Response(hardcoded_roadunblock, status=status.HTTP_200_OK)

class LibraryViewSet(viewsets.ModelViewSet):
    queryset = Library.objects.all()
    serializer_class = LibrarySerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    @action(detail=False, methods=["get"])
    def get_user_library(self, request):
        library = Library.objects.filter(reader=request.user)

        serializer = LibraryBookSerializer(library, many=True)

        return Response(serializer.data)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)

        serializer.is_valid(raise_exception=True)

        serializer.save(reader=request.user)

        self.perform_create(serializer)

        headers = self.get_success_headers(serializer.data)

        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
    
    def partial_update(self, request, *args, **kwargs):
        instance = self.get_object()

        serializer = self.get_serializer(instance, data=request.data, partial=True)

        serializer.is_valid(raise_exception=True)

        self.perform_update(serializer)

        return Response(status = status.HTTP_202_ACCEPTED)

    @action(detail=True, methods=["delete"])
    def delete_entry(self, request, *args, **kwargs):
        instance = self.get_object()

        instance.delete()

        return Response(status=status.HTTP_204_NO_CONTENT)






