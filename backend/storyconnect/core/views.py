from rest_framework.views import APIView
from rest_framework.response import Response

from .serializers import (
    UserUidConversionSerializer,
    ProfileSerializer,
    ActivitySerializer,
    AnnouncementSerializer,
    ProfileImageSerializer,
    ImageUploader,
)
from .models import Profile, Activity, Announcement
from rest_framework import viewsets, status
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from django.contrib.auth.models import User
from rest_framework.decorators import action

from storyconnect.auth import FirebaseAuthentication
from storyconnect.permissions import IsOwnerOrReadOnly


class UserUidConversion(APIView):
    # UID is now taken from the URL directly as a keyword argument
    def get(self, request, id, format=None):
        if not id:
            return Response(
                {"error": "UID is required."}, status=status.HTTP_400_BAD_REQUEST
            )

        django_user = User.objects.filter(id=id).first()

        user = FirebaseAuthentication.get_firebase_user(django_user.username)

        if user and user.display_name:
            # Ensure the serializer is initialized with 'data' as a keyword argument
            serializer = UserUidConversionSerializer(
                data={"username": user.display_name}
            )
            if serializer.is_valid():
                return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                # In case of serializer errors, return a 400 Bad Request with the error messages
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        elif user:
            serializer = UserUidConversionSerializer(
                data={"username": "Display Name not set"}
            )
            if serializer.is_valid():
                return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                # In case of serializer errors, return a 400 Bad Request with the error messages
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            # If the user or display_name is not found, return a 404 Not Found
            return Response(
                {"error": "User not found or display name not set."},
                status=status.HTTP_404_NOT_FOUND,
            )


# A view to verify display name uniqueness on a profile before saving
class ProfileDisplayNameVerification(APIView):
    authentication_classes = []

    def post(self, request, format=None):
        if not request.data.get("display_name"):
            return Response({"success": False}, status=status.HTTP_400_BAD_REQUEST)

        # Get the display name from the request
        display_name = request.data.get("display_name")

        # Check if the display name is unique
        if Profile.objects.filter(display_name=display_name).exists():
            return Response({"success": False}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"success": True}, status=status.HTTP_200_OK)

# A view to upload a profile image
class ProfileImageUpload(APIView):
    serializer_class = ProfileImageSerializer
    authentication_classes = [IsOwnerOrReadOnly]

    def post(self, request, format=None):
        # check if the uploaded data is valid
        serializer = self.serializer_class(data=request.data)

        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            # Get the image and id from the request
            image = serializer.validated_data.get("image")

            uid = request.user.username

            # Upload the image to Firebase Storage
            image_url = ImageUploader.upload_to_firestore(image, uid)

            if image_url is None:
                return Response({"success": False}, status=status.HTTP_400_BAD_REQUEST)

            # Save the image URL to the profile
            profile = Profile.objects.filter(user=request.user).first()
            profile.image_url = image_url
            profile.save()
            print(image_url)

            # Return the profile containing the image URL
            serializer = ProfileSerializer(profile)
            return Response(serializer.data, status=status.HTTP_200_OK)

    def delete(self, request, format=None):
        try:
            profile = Profile.objects.filter(user=request.user).first()
            profile.image_url = None
            profile.save()
            return Response(
                {"success": True, "message": "Succesfully Deleted Profile Image"},
                status=status.HTTP_200_OK,
            )
        except Exception as e:
            print(e)
            return Response(
                {"success": False, "message": "Error Deleting Profile Image"},
                status=status.HTTP_400_BAD_REQUEST,
            )

class ProfileViewSet(viewsets.ModelViewSet):
    queryset = Profile.objects.all().prefetch_related("user")
    serializer_class = ProfileSerializer
    authentication_classes = [] # No authentication required for reads, 
                                # though the default permissions protect against 'bad' writes 
    lookup_field = "user__username"

    def get_object(self):
        """
        Returns the object the view is displaying.
        """
        username = self.kwargs.get("user__username")
        user = User.objects.get(username=username)
        profile, created = self.queryset.get_or_create(user=user)

        if created:
            profile.bio = "This user has not set a bio yet."
            profile.save()
            pass

        return profile
    

# A view to get Profile Information based on a display Name
class GetProfileByDisplayName(APIView):
    '''
    Gets a user Profile username by Display Name.
    '''
    queryset = Profile.objects.all().prefetch_related("user")
    serializer_class = ProfileSerializer
    authentication_classes = [] # No authentication required for reads, 
                                # though the default permissions protect against 'bad' writes 
    lookup_field: str = 'display_name'

    def get(self, request, *args, **kwargs):
        '''Returns data based on a display name rather than a userId'''

        print(f"request {request}")

        displayName = self.kwargs.get("display_name")
        print(f"Found Display Name {displayName}")

        profile = Profile.objects.get(display_name = displayName)

        print( f"Username: '{profile.user.username}' from DisplayName:  {displayName}")

        return Response(profile.user.username, status=status.HTTP_200_OK)

class ActivityViewSet(viewsets.ModelViewSet):
    queryset = Activity.objects.all().prefetch_related("user")
    serializer_class = ActivitySerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    @action(detail=False, url_path="by_writer/(?P<user_id>[^/.]+)")
    def by_writer(self, request, user_id=None):
        """
        Returns activities for a specific user.
        """
        if not user_id:
            return Response(
                {"error": "User ID is required"}, status=status.HTTP_400_BAD_REQUEST
            )

        activities = self.queryset.filter(user__username=user_id)
        serializer = self.get_serializer(activities, many=True)
        return Response(serializer.data)

    def perform_create(self, serializer):
        serializer.save(user_id=self.request.user.id)


class AnnouncementViewSet(viewsets.ModelViewSet):
    queryset = Announcement.objects.all().prefetch_related("user")
    serializer_class = AnnouncementSerializer
    permission_classes = [IsAuthenticatedOrReadOnly, IsOwnerOrReadOnly]

    @action(detail=False, url_path="by_writer/(?P<user_id>[^/.]+)")
    def by_writer(self, request, user_id=None):
        """
        Returns activities for a specific user.
        """
        if not user_id:
            return Response(
                {"error": "User ID is required"}, status=status.HTTP_400_BAD_REQUEST
            )

        activities = self.queryset.filter(user__username=user_id)
        serializer = self.get_serializer(activities, many=True)
        return Response(serializer.data)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
