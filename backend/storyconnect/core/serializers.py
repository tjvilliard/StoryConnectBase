from rest_framework import serializers



class UserUidConversionSerializer(serializers.Serializer):
    username = serializers.CharField()
