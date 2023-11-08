from django.contrib.auth.models import User
from firebase_admin import auth
from rest_framework import authentication

from .exceptions import FirebaseError
from .exceptions import InvalidAuthToken
from .exceptions import NoAuthToken

class FirebaseAuthentication(authentication.BaseAuthentication):
    def get_firebase_user(uid):
        try:
            user = auth.get_user(uid)
            return user
        except auth.AuthError as e:
            print('Error fetching user data:', e)
            return None
    def authenticate(self, request):
        auth_header = request.META.get("HTTP_AUTHORIZATION")

        # # TODO: Remove this when done testing
        # postman = request.META.get("HTTP_POSTMAN_TOKEN")
        # if postman:
        #     return None

        if not auth_header:
            raise NoAuthToken("No auth token provided")

        id_token = auth_header.split(" ").pop()

        decoded_token = None
        try:
            decoded_token = auth.verify_id_token(id_token)


        except Exception:
            raise InvalidAuthToken("Invalid auth token")

        if not id_token or not decoded_token:
            return None

        try:
            uid = decoded_token.get("uid")
        except Exception:
            raise FirebaseError()

        user, created = User.objects.get_or_create(username=uid)
        #user.profile.last_activity = timezone.localtime()

        return (user, None)