from rest_framework import status
from rest_framework.exceptions import APIException

class ContinuityCheckerNullTextError(Exception):
    def __init__(self):
        self.message = "No text provided to continuity checker."
        super().__init__(self.message)

class StatementSheetInvalidDocumentError(Exception):
    def __init__(self):
        self.message = "Invalid document provided to StatementSheet."
        super().__init__(self.message)