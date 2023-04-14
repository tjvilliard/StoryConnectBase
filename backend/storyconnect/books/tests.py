from django.test import TestCase
from django.contrib.auth.models import User
from rest_framework.test import APIClient
from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse

from .models import Book, Chapter, Character, Location, Scene


# class BookTestCase(APITestCase):
#     def setUp(self):
#         self.user = User.objects.create_user(username='testuser', password='testpassword', email='testmail')
#         self.client = APIClient()
#         self.client.force_authenticate(user=self.user)
#         self.book = Book.objects.create(
#             title="Test Book",
#             author="Test Author",
#             owner=self.user,
#             language="English",
#             target_audience=1,
#             copyright=1,
#             titlepage="Test Title Page",
#             synopsis="Test synopsis"
#         )

#     def test_create_book(self):
#         response = self.client.post('/api/books/', {
#             'title': 'New Book',
#             'author': 'New Author',
#             'language': 'English',
#             'target_audience': 1,
#             'copyright': 1,
#             'titlepage': 'New Title Page',
#             'synopsis': 'New synopsis'
#         })
#         self.assertEqual(response.status_code, 201)

#     def test_update_book(self):
#         response = self.client.put(f'/api/books/{self.book.id}/', {
#             'title': 'Updated Book',
#             'author': 'Updated Author',
#             'language': 'English',
#             'target_audience': 2,
#             'copyright': 2,
#             'titlepage': 'Updated Title Page',
#             'synopsis': 'Updated synopsis'
#         })
#         print(response.data)
#         self.assertEqual(response.status_code, 200)

#     def test_delete_book(self):
#         response = self.client.delete(f'/api/books/{self.book.id}/')
#         self.assertEqual(response.status_code, 204)

# Add test cases for Chapter, Character, Location, and Scene models similarly
class BookViewSetTestCase(APITestCase):

    def setUp(self):
        # Create a user
        self.user = User.objects.create_user(username='testuser', password='testpassword')

        # Authenticate the user
        self.client.force_authenticate(user=self.user)

        # Create a sample book
        self.book = Book.objects.create(
            title='Test Book',
            author='Test Author',
            owner=self.user,
            language='English',
            target_audience=1,
            copyright=1,
            synopsis='This is a test book.',
            titlepage='Title page content.'
        )

        # URL for the books API
        self.books_url = reverse('book-list')
    
    def test_create_book(self):
        data = {
            'title': 'New Book',
            'author': 'New Author',
            'language': 'English',
            'target_audience': 1,
            'copyright': 1,
            'synopsis': 'This is a new book.',
            'titlepage': 'Title page content for the new book.'
        }
        response = self.client.post(self.books_url, data=data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Book.objects.count(), 2)

    def test_update_book(self):
        updated_title = 'Updated Test Book'
        book_detail_url = reverse('book-detail', kwargs={'pk': self.book.pk})
        data = {
            'title': updated_title,
            'author': self.book.author,
            'language': self.book.language,
            'target_audience': self.book.target_audience,
            'copyright': self.book.copyright,
            'synopsis': self.book.synopsis,
            'titlepage': self.book.titlepage,
        }
        response = self.client.put(book_detail_url, data=data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.book.refresh_from_db()
        self.assertEqual(self.book.title, updated_title)

    def test_delete_book(self):
        book_detail_url = reverse('book-detail', kwargs={'pk': self.book.pk})
        response = self.client.delete(book_detail_url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(Book.objects.count(), 0)
