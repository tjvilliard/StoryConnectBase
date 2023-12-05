from time import sleep

from django.contrib.auth.models import User
from firebase_admin import auth
from rest_framework import authentication

from .exceptions import FirebaseError
from .exceptions import InvalidAuthToken
from .exceptions import NoAuthToken
from firebase_admin._auth_utils import InvalidIdTokenError

import logging

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

        print(auth_header)

        if not auth_header:
            raise NoAuthToken("No auth token provided")

        id_token: str = auth_header.split(" ").pop()

        decoded_token: dict = None
        try:
            # This should be used in production on an actual server, uncomment this out
            #decoded_token = auth.verify_id_token(id_token, None, False)

            # This can and probably should be used when running the project locally, as firebase can fail on localhost. 
            decoded_token = FirebaseAuthentication.authenticate_token_wrapper(id_token)

        except Exception as e:
            logging.exception(msg = e, exc_info = True, stack_info = True, stacklevel = 1)
            raise InvalidAuthToken("Invalid auth token")

        if not id_token or not decoded_token:
            return None

        try:
            uid = decoded_token.get("uid")
        except Exception as e:
            logging.exception(msg = e,exc_info = True, stack_info = True, stacklevel = 1)
            raise FirebaseError()

        user, created = User.objects.get_or_create(username = uid)

        return (user, None)
    
    # Written in response to a firebase 'based' error where the computer clock not being synchronized would throw a firebase auth error
    # because firebase doesn't allow for a margin of error for time in computer clocks. This happens on localhost all the time. 
    # https://stackoverflow.com/questions/71915309/token-used-too-early-error-thrown-by-firebase-admin-auths-verify-id-token-metho
    @staticmethod
    def authenticate_token_wrapper(id_token) -> dict:
        '''
        For now: for use in localhost only.
        Wrapper for handling a firebase request 
        '''
        try:
            decoded_token = auth.verify_id_token(id_token)

        except (InvalidIdTokenError) as idErr:
            error__str__: str = str(idErr)

            print(error__str__)

            if(error__str__.find("Token used too early") > -1):
                print("")
                print("Handling Timing Error")
                print("")
                times__str__: str = error__str__.split(",")[1].split("<")
                time_0: int = int(times__str__[0])
                time_1: int = int(times__str__[1].split(".")[0])
                time: int = time_1 - time_0
                sleep(time)
                return auth.verify_id_token(id_token)
            
        except (Exception) as err:
            logging.exception(err)

        return decoded_token