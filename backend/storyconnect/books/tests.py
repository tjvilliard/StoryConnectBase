from django.test import TestCase
from models import *

# Create your tests here.


class BookTestCase(TestCase):
    def setUp(self):
        Book.objects.create(title="The Hobbit", author="J.R.R. Tolkien", content="A hobbit is a small human-like creature that lives in a hole in the ground. They are very peaceful and like to eat and drink.")