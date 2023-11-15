from rest_framework.views import APIView
from rest_framework.response import Response
from .authentication import FirebaseAuthentication 
from .serializers import UserUidConversionSerializer, ProfileSerializer, ActivitySerializer, AnnouncementSerializer
from .models import Profile, Activity, Announcement
from rest_framework import viewsets, status
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from .permissions import IsOwnerOrReadOnly
from django.contrib.auth.models import User
from rest_framework.decorators import action



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

class ProfileViewSet(viewsets.ModelViewSet):
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
    permission_classes = [IsOwnerOrReadOnly]
    lookup_field = 'user__username'

    def get_queryset(self):
        """
        This view should return a list of all profiles
        for currently authenticated users.
        """
        return Profile.objects.all()

    def get_object(self):
        """
        Returns the object the view is displaying.
        """
        username = self.kwargs.get('user__username')
        print(username)
        user = User.objects.get(username=username)
        profile, created = Profile.objects.get_or_create(user=user)

        if created:
            profile.bio = "This user has not set a bio yet."
            profile.save()
            pass

        return profile



class ActivityViewSet(viewsets.ModelViewSet):
    queryset = Activity.objects.all()
    serializer_class = ActivitySerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    @action(detail=False, url_path='by_writer/(?P<user_id>[^/.]+)')
    def by_writer(self, request, user_id=None):
        """
        Returns activities for a specific user.
        """
        if not user_id:
            return Response({"error": "User ID is required"}, status=status.HTTP_400_BAD_REQUEST)

        activities = self.queryset.filter(user__username=user_id)
        serializer = self.get_serializer(activities, many=True)
        return Response(serializer.data)
    def perform_create(self, serializer):
        serializer.save(user_id=self.request.user.id)


class AnnouncementViewSet(viewsets.ModelViewSet):
    queryset = Announcement.objects.all()
    serializer_class = AnnouncementSerializer
    permission_classes = [IsAuthenticatedOrReadOnly, IsOwnerOrReadOnly]

    @action(detail=False, url_path='by_writer/(?P<user_id>[^/.]+)')
    def by_writer(self, request, user_id=None):
        """
        Returns activities for a specific user.
        """
        if not user_id:
            return Response({"error": "User ID is required"}, status=status.HTTP_400_BAD_REQUEST)

        activities = self.queryset.filter(user__username=user_id)
        serializer = self.get_serializer(activities, many=True)
        return Response(serializer.data)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)