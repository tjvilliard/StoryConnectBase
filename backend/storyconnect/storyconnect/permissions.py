from rest_framework import permissions
from .auth import FirebaseAuthentication


class IsOwnerOrReadOnly(permissions.BasePermission, FirebaseAuthentication):
    """
    Custom permission to only allow owners of an object to edit it.
    Assumes the model instance has an 'user' attribute.
    """

    def has_object_permission(self, request, view, obj):
        # Read permissions are allowed to any request (authenticated or not),
        # so we'll always allow GET, HEAD or OPTIONS requests.
        print(request.method)
        if request.method in permissions.SAFE_METHODS:
            print("SAFE_METHODS")
            return True

        # Check if the user is authenticated
        authenticated_user = self.authenticate(request)
        if not authenticated_user:
            return False

        # Write permissions are only allowed to the owner of the profile.
        return obj.user == authenticated_user