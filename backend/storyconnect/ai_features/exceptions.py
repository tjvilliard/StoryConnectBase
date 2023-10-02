from rest_framework import status
from rest_framework.exceptions import APIException

class ContinuityCheckerNullTextError(Exception):
    def __init__(self):
        self.message = "No text provided to continuity checker."
        super().__init__(sefl.message)
    