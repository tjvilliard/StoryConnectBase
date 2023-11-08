
from rest_framework.views import APIView
from core.authentication import FirebaseAuthentication
from serializers import UserUidConversionSerializer
from rest_framework.response import Response
from rest_framework import status
# Create your views here.
# class UserInformation(viewsets.ModelViewSet):
#     queryset = UserInformation.objects.all()
#     serializer_class = UserInformationSerializer

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


class UserUidConversion(APIView):
    def get(self, request, format=None):
        uid = self.kwargs.get('uid')

        if not uid:
            return Response(status=status.HTTP_400_BAD_REQUEST)
    
        user = FirebaseAuthentication.get_firebase_user(uid)
        # create new serializer with the user data
        serializer = UserUidConversionSerializer(username=user.display_name)

        return Response(serializer.data)