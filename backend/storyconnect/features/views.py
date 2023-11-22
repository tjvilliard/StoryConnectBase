from rest_framework.response import Response
from rest_framework.views import APIView
from features import models as features_models
from .serializers import GenreTagSerializer, ChapterTaggingSerializer
from books import models as book_models

# # Create your views here.
class GenreTagView(APIView):

    def get(self,request, book_id):
        intended_book = book_models.Book.objects.get(id = book_id)
        book_genres = features_models.GenreTagging.objects.create(book=intended_book)
        book_genres.save()
        # book_genres = self.create(book_id=book_id)  
        chapter_genres_serializer = GenreTagSerializer(book_genres, many=True)

        content = {
            'book_id': book_genres.book,
            'genre': book_genres.genre
        }
        return Response(content)

class ChapterTagView(APIView):
    def get(self,request, book_id, chapter_num):
        intended_book = book_models.Book.objects.get(id = book_id)
        chapter_genre = features_models.ChapterTagging.objects.create(book=intended_book, chapter_number = chapter_num)
        # chapter_genre = book_genre.get(chapter_number = chapter_num)
        chapter_genre.save()
        chapter_genres_serializer = ChapterTaggingSerializer(chapter_genre, many=True)

        content = {
            'book_id': chapter_genre.book,
            'chapter_number' : chapter_genre.chapter_number,
            'genre': chapter_genre.genre
        }
        return Response(content)