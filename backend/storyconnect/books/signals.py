from django.db.models.signals import post_save
from django.contrib.auth.models import User
from django.dispatch import receiver

from backend.storyconnect.books.models import NarrativeElementAttributeType, NarrativeElementType
from .constants import (
    CHARACTER_TYPE_NAME,
    LOCATION_TYPE_NAME,
    DEFAULT_CHARACTER_ATTRIBUTES,
    DEFAULT_LOCATION_ATTRIBUTES
)

@receiver(post_save, sender=User)
def create_default_entries(sender, instance, created, **kwargs):
    if created:  # Check if the user instance is new
        # Create default NarrativeElementTypes
        character_type = NarrativeElementType.objects.create(user=instance, name=CHARACTER_TYPE_NAME)
        location_type = NarrativeElementType.objects.create(user=instance, name=LOCATION_TYPE_NAME)

        # Create default AttributeTypes for Character
        for attr_type in DEFAULT_CHARACTER_ATTRIBUTES:
            NarrativeElementAttributeType.objects.create(user=instance, name=attr_type, applicable_to=character_type)

        # Create default AttributeTypes for Location
        for attr_type in DEFAULT_LOCATION_ATTRIBUTES:
            NarrativeElementAttributeType.objects.create(user=instance, name=attr_type, applicable_to=location_type)
