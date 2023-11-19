from rest_framework import permissions
from .authentication import FirebaseAuthentication


class IsOwnerOrReadOnly(permissions.BasePermission, FirebaseAuthentication):
    """
    Custom permission to only allow owners of an object to edit it.
    Assumes the model instance has an 'user' attribute.
    """

    def has_object_permission(self, request, view, obj):
        # Read permissions are allowed to any authenticated request,
        # so we'll always allow GET, HEAD or OPTIONS requests.
        if request.method in permissions.SAFE_METHODS:
            return True

        # Write permissions are only allowed to the owner of the profile.
        return obj.user == request.user
