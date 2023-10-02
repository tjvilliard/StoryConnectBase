from django.test import TestCase
from .models import *
from books.models import Book
# Create your tests here.
class StatementSheetTests(TestCase):
    def setUp(self):
        self.book = Book.objects.create(title="Test Book")
        self.document = "<Statements>\n<Characters>\n<John-Doe>John Doe has blue eyes.\n John Doe is tall.\n</John-Doe>\n<Jane-Doe>Jane Doe has blonde hair.\n Jane Doe is 23 years old.\n</Jane-Doe>\n</Characters>\n<Locations>\n<New-York>New York is a city.\n New York is in the United States.\n</New-York>\n\n</Locations>\n</Statements>"
        self.new_document = "<Statements>\n<Characters>\n<John-Doe>John Doe has the upper hand.\n</John-Doe>\n</Characters>\n<Locations>\n<Kings-Landing>Kings Landing is the capital of the Westeros.\n</Kings-Landing>\n</Locations>\n</Statements>"
        self.sheet = StatementSheet.objects.create(book=self.book, document=self.document)
    
    def test_get_characters(self):
        characters = self.sheet.get_characters()
        self.assertEqual(characters, ['John-Doe', 'Jane-Doe'])

    def test_get_character_statements(self):
        statements = self.sheet.get_character_statements('John-Doe')
        self.assertEqual(statements, 'John Doe has blue eyes.\n John Doe is tall.\n')
    
    def test_get_locations(self):
        locations = self.sheet.get_locations()
        self.assertEqual(locations, ['New-York'])
    
    def test_get_location_statements(self):
        statements = self.sheet.get_location_statements('New-York')
        self.assertEqual(statements, 'New York is a city.\n New York is in the United States.\n')
    
    def test_merge_sheets(self):
        self.sheet.merge_sheets(self.new_document)

        locations = self.sheet.get_locations()
        self.assertEqual(locations, ['New-York', 'Kings-Landing'])

        statements = self.sheet.get_character_statements('John-Doe')
        self.assertEqual(statements, 'John Doe has blue eyes.\n John Doe is tall.\n John Doe has the upper hand.\n')