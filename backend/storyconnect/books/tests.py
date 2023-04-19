<<<<<<< HEAD
from django.contrib.auth.models import User
from .models import *
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient
from rest_framework.test import APITestCase
from rest_framework import status
from views import *

class UserBookCreationTestCase(APITestCase):
    """
    Test suite for User and Book Properties
    """
    def setUp(self):
=======
from django.test import TestCase
from django.contrib.auth.models import User
from rest_framework.test import APIClient
from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse

from .models import Book, Chapter, Character, Location, Scene
>>>>>>> feature/backend-construction

        # Book.objects.create(title= "Demo item 2",description= "This is a description for demo 2",price= 700,stock= 15)

<<<<<<< HEAD
=======
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
        self.user = User.objects.create_user(username='testuser', password='testpassword', email="test@mail.com")

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
        self.books_url = '/api/books/'
    
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





class UserBookCreationTestCase(APITestCase):
    """
    Test suite for User and Book Properties
    """
    def setUp(self):

        # Book.objects.create(title= "Demo item 2",description= "This is a description for demo 2",price= 700,stock= 15)

>>>>>>> feature/backend-construction
        # self.items = Book.objects.all()

        # create user
        self.user = User.objects.create_user(
            username='testuser1', 
            password='this_is_a_test',
            email='testuser1@test.com'
        )
        # create a book for the user
        self.userbook = Book.objects.create(
<<<<<<< HEAD
            title = "Red Queen", 
            author = "Victoria Aveyard", 
            owner = self.user,
            language = 1,
            target_audience = 1,
=======
            title="Red Queen", 
            author = "Victoria Aveyard", 
            owner = self.user,
            language=1,target_audience = 1,
>>>>>>> feature/backend-construction
            synopsis = "This is the book synopsis.",
            copyright = 1, 
            titlepage = "This is the book title page.")
        

        #The app uses token authentication
        # self.token = Token.objects.get(user = self.user)
<<<<<<< HEAD
        self.client = APIClient()
=======
        # self.client = APIClient()
>>>>>>> feature/backend-construction
        
        # #We pass the token in all calls to the API
        # self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)

    # testing how many books are there essentially testing perform_create
    def test_book_count(self):
        '''
        test BookViewSet list method
        '''
        self.assertEqual(Book.objects.count(), 2)
        response = self.client.get('/books/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        
    # testing perform query to only show the author's books
    def test_author_all_books(self):
        authorbooks = Book.objects.filter(owner = self.user)
        for b in authorbooks:
            response = self.client.get(f'/books/{b.owner}/') # not sure
            self.assertEqual(response.status_code, status.HTTP_200_OK)                           
    
<<<<<<< HEAD
    def test_a_book_property(self):
        response = self.client.get(f'/books/{self.userbook}')
        self.assertEqual(response.status_code, status.HTTP_200_OK)                           
        self.assertEqual(Book.objects.get().__getattribute__(), 'to be made')

    def test_getting_book_properties(self):

=======
    def test_getting_book_properties(self):
>>>>>>> feature/backend-construction
        attr_dict = {
            'title'               : "Red Queen",
            'author'              : "Victoria Aveyard",
            'language'            : 1,
            'target_audience'     : 1,
            'synopsis'            : "This is the book synopsis.",
            'copyright'           : 1,
            'titlepage'           : "This is the book title page."}
        # self.assertEqual(self.userbook.title, title)
        # self.assertEqual(self.userbook.author, author)
        # self.assertEqual(self.userbook.language, language)
        # self.assertEqual(self.userbook.target_audience, target_audience)
        # self.assertEqual(self.userbook.synopsis, synopsis)
        # self.assertEqual(self.userbook.copyright, copyright_chosen)
        # self.assertEqual(self.userbook.titlepage, titlepage)
        self.assertEqual(self.userbook.__getattribute__.__dict__(), attr_dict)
        # self.userbook.queryset

    def test_retrieve_all_book(self):
<<<<<<< HEAD
        all_books = Book.objects.all()
        response = self.client.get(f'/books/')
        # attr_dict = {
        #     'title'               : "Red Queen",
        #     'author'              : "Victoria Aveyard",
        #     'language'            : 1,
        #     'target_audience'     : 1,
        #     'synopsis'            : "This is the book synopsis.",
        #     'copyright'           : 1,
        #     'titlepage'           : "This is the book title page."}
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    

    def test_updating_book_properties(self):
        self.userbook.title = "Dune"
        bookview = BookViewSet.update() # needs fixing
=======
        bookview = BookViewSet.retrieve()
        attr_dict = {
            'title'               : "Red Queen",
            'author'              : "Victoria Aveyard",
            'language'            : 1,
            'target_audience'     : 1,
            'synopsis'            : "This is the book synopsis.",
            'copyright'           : 1,
            'titlepage'           : "This is the book title page."}
        self.assertEqual(bookview.data, attr_dict)
    
    # testing to miss the non-null attribute when creating or something
    def test_filling_in_with_invalid_input_for_attributes(self):

        return 0

    def test_updating_book_properties(self):
        self.userbook.title = "Dune"
        bookview = BookViewSet.update()
>>>>>>> feature/backend-construction
        attr_dict = {
            'title'               : "Dune",
            'author'              : "Victoria Aveyard",
            'language'            : 1,
            'target_audience'     : 1,
            'synopsis'            : "This is the book synopsis.",
            'copyright'           : 1,
            'titlepage'           : "This is the book title page."}        
        self.assertEqual(bookview.data, attr_dict)   

    def test_getting_a_specific_book(self):
        dune = Book.objects.filter(title="Dune")
<<<<<<< HEAD
        response = self.client.get(f'/books/{dune}')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        
content="A hobbit is a small human-like creature that lives in a hole in the ground. They are very peaceful and like to eat and drink."
=======
        response = self.client.get(f'/books/{dune.id}')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        
content="A hobbit is a small human-like creature that lives in a hole in the ground. They are very peaceful and like to eat and drink."
>>>>>>> feature/backend-construction
