from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .authentication import FirebaseAuthentication 
from .serializers import UserUidConversionSerializer

class UserUidConversion(APIView):
    # UID is now taken from the URL directly as a keyword argument
    def get(self, request, uid, format=None):
        if not uid:
            return Response({"error": "UID is required."}, status=status.HTTP_400_BAD_REQUEST)
        
        user = FirebaseAuthentication.get_firebase_user(uid)
        if user and user.display_name:
            # Ensure the serializer is initialized with 'data' as a keyword argument
            serializer = UserUidConversionSerializer(data={'username': user.display_name})
            if serializer.is_valid():
                return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                # In case of serializer errors, return a 400 Bad Request with the error messages
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            # If the user or display_name is not found, return a 404 Not Found
            return Response({"error": "User not found or display name not set."}, status=status.HTTP_404_NOT_FOUND)

