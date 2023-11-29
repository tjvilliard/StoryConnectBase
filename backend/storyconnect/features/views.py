from rest_framework.response import Response
from rest_framework.views import APIView
from models import *
from serializers import *
from books import models as book_models
from books import serializers as book_serializers

# # Create your views here.

class GenreTaggingAPIView(APIView):

    def get(self, request, *args, **kwargs):
        book_id = request.query_params.get('book_id')
        intended_book = book_models.Book.objects.get(pk = book_id)
        the_book_from_tag = GenreTag.objects.get(book=intended_book)
        serializer = GenreTagSerializer(the_book_from_tag, many=False)

        return Response(serializer.data)
    
class ChapterTaggingAPIView(APIView):
    def get(self, request, *args, **kwargs):
        book_id = request.query_params.get('book_id')
        chapter_num = request.query_params.get('chapter_num')
        intended_book = book_models.Book.objects.get(id = book_id)
        the_chapter_from_tag = ChapterTagging.objects.get(book=intended_book, chapter_number = chapter_num)
        serializer = ChapterTagging(the_chapter_from_tag, many=False)

        return Response(serializer.data)

# class ChapterTaggingViewSet(APIView):
#     def get(self,request, book_id, chapter_num):
#         intended_book = book_models.Book.objects.get(id = book_id)
#         chapter_genre = features_models.ChapterTagging.objects.create(book=intended_book, chapter_number = chapter_num)
#         # chapter_genre = book_genre.get(chapter_number = chapter_num)
#         chapter_genre.save()
#         chapter_genres_serializer = features_serializers.ChapterTaggingSerializer(chapter_genre, many=True)

#         content = {
#             'book_id': chapter_genre.book,
#             'chapter_number' : chapter_genre.chapter_number,
#             'genre': chapter_genre.genre
#         }
#         return Response(content)

# class GenreTaggingViewSet(APIView):

    # @action(detail=True, methods=['get'])
    # def get_genres(self,request, pk=None):
    #     intended_book = book_models.Book.objects.get(pk = pk)
    #     book_genres = features_models.GenreTagging.objects.create(book=intended_book)
    #     book_genres.save()
    #     # book_genres = self.create(book_id=book_id)  
    #     chapter_genres_serializer = features_serializers.GenreTaggingSerializer(book_genres, many=True)

    #     content = {
    #         'book_id': book_genres.book,
    #         'genre': book_genres.genre
    #     }
    #     return Response(content)