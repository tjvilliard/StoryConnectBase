from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import action
from features import models as features_models
from features import serializers as features_serializers
from books import models as book_models
from books import serializers as book_serializers

# # Create your views here.

class GenreTaggingAPIView(APIView):
    serializer_class = features_serializers.GenreTaggingSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    #authentication_classes = (TokenAuthentication,)
    queryset = features_models.GenreTagging.objects.all().prefetch_related("book")
    
    @action(detail=True, methods=["get"])
    def get(self, request, *args, **kwargs):
        
        genretags = self.queryset.filter(book__id = kwargs.get('book_id'))
        serializer=features_serializers.GenreTaggingSerializer(genretags, many=True)
        return Response(serializer.data)
    
class ChapterTaggingAPIView(APIView):
    def get(self, request, *args, **kwargs):
        book_id = request.query_params.get('book_id')
        chapter_num = request.query_params.get('chapter_num')
        intended_book = book_models.Book.objects.get(id = book_id)
        the_chapter_from_tag = features_models.ChapterTagging.objects.get(book=intended_book, chapter_number = chapter_num)
        serializer = features_serializers.ChapterTaggingSerializer(the_chapter_from_tag, many=False)

        return Response(serializer.data)