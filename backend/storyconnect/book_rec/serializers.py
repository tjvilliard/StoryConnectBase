from rest_framework import serializers
from rest_framework import status
from rest_framework.exceptions import APIException
from book_rec.models import *

class Book_Based_Rec_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Book_Based_Rec
        fields = "__all__"

class User_Based_Rec_Serializer(serializers.ModelSerializer):
    class Meta:
        model = User_Based_Rec
        fields = "__all__"

class Book_Rating_Serializer(serializers.ModelSerializer):
    class Meta:
        model = Book_Rating
        fields = "__all__" 