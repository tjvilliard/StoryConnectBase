from django.contrib.auth.models import User
from rest_framework.test import APIClient
from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse

from .models import Book
# from .models import Chapter, Character, Location, Scene

# Add test cases for Chapter, Character, Location, and Scene models similarly
class BookViewSetTestCase(APITestCase):

    def setUp(self):
        # Create a user
        self.user = User.objects.create_user(username='testuser', password='testpassword', email="test@mail.com")

        # initiate APICLient
        self.client = APIClient()

        # Authenticate the user
        self.client.force_authenticate(user=self.user)

        # Create a sample book
        self.book = Book.objects.create(
            title='Test Book',
            owner=self.user,
            language='English',
            target_audience=1,
            copyright=1,
            synopsis='This is a test book.',
            titlepage='Title page content.'
        )

        # URL for the books API
        self.books_url = '/books/'
    
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
        book_detail_url = reverse('books-detail', kwargs={'pk': self.book.pk})
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
        book_detail_url = reverse('books-detail', kwargs={'pk': self.book.pk})
        response = self.client.delete(book_detail_url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(Book.objects.count(), 0)

class UserBookCreationTestCase(APITestCase):
    """
    Test suite for User and Book Properties
    """
    def setUp(self):

        # create user
        self.user = User.objects.create_user(
            username='testuser', 
            password='this_is_a_test',
            email='testuser@test.com'
        )
        # create a book for the user
        self.userbook = Book.objects.create(
            title           = "Red Queen", 
            author          = "Victoria Aveyard", 
            owner           = self.user,
            language        = 1,
            target_audience = 1,
            synopsis        = "This is the book synopsis.",
            copyright       = 1, 
            titlepage       = "This is the book title page.")
        

        #The app uses token authentication
        # self.token = Token.objects.get(user = self.user)
        self.client = APIClient()
        
        # #We pass the token in all calls to the API
        # self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)

    # testing how many books are there essentially testing perform_create
    def test_book_count(self):
        '''
        test BookViewSet list method
        '''
        self.assertEqual(Book.objects.count(), 1)
        response = self.client.get('/api/books/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        
    # testing perform query to only show the author's books
    def test_author_all_books(self):
        authorbooks = Book.objects.filter(owner = self.user)
        for b in authorbooks:
            response = self.client.get(f'/books/{b.id}/') # not sure
            self.assertEqual(response.status_code, status.HTTP_200_OK)                           
    
    # testing gettting the userbook book properties - using non-sql filter method
    def test_getting_userbook_properties(self):
        attr_dict = {
            'title'               : "Red Queen",
            'author'              : "Victoria Aveyard",
            'language'            : 1,
            'target_audience'     : 1,
            'synopsis'            : "This is the book synopsis.",
            'copyright'           : 1,
            'titlepage'           : "This is the book title page."}
        response = self.client.get(f"/api/books/{self.userbook.pk}")
        self.assertEqual(response.status_code, status.HTTP_200_OK) 
        self.assertEqual(self.userbook.__getattribute__.__dict__(), attr_dict)
        # self.userbook.queryset
    
    # testing gettting a specific book properties - using sql filter method
    def test_getting_a_specific_book(self):
        dune = Book.objects.filter(title="Red Queen")
        response = self.client.get(f'/api/books/{dune.pk}')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    
    # testing to retrieve all books in the database
    def test_retrieve_all_book(self):
        get_all_book = self.client.get('/api/books/')
        self.assertEqual(get_all_book.status_code, status.HTTP_200_OK)

    # testing updating a certain book properties
    def test_updating_book_properties(self):
        attr_dict = {
            'title'               : "Dune",
            'author'              : "Victoria Aveyard",
            'language'            : 1,
            'target_audience'     : 1,
            'synopsis'            : "This is the book synopsis.",
            'copyright'           : 1,
            'titlepage'           : "This is the book title page."}     
        update_book_prop = self.client.put(f'/books/{self.userbook.id}', data=attr_dict)
        self.assertEqual(update_book_prop.status_code, status.HTTP_200_OK)
        self.assertEqual(self.userbook.__getattribute__(), attr_dict)

    # testing creating a new book to the database
    def test_create_a_book(self):
        book_create = {
            'title'               : "Glass Sword",
            'author'              : "Victoria Aveyard",
            'language'            : 1,
            'target_audience'     : 1,
            'synopsis'            : "This is the book synopsis too.",
            'copyright'           : 1,
            'titlepage'           : "This is the book title page too."}
        create_a_book = self.client.post('/api/books/', data=book_create)
        self.assertEqual(Book.objects.count(), 2)
        self.assertEqual(create_a_book.status_code, status.HTTP_200_OK)
        newbook = Book.objects.filter(title="Glass Sword")
        response = self.client.get(f'/api/books/{newbook}')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    
    # testing deleting a book in the database
    def test_delete_a_book(self):
        #  TODO: need to fix this
        book_delete = {
            'title'               : "Glass Sword",
            'author'              : "Victoria Aveyard",
            'language'            : 1,
            'target_audience'     : 1,
            'synopsis'            : "This is the book synopsis too.",
            'copyright'           : 1,
            'titlepage'           : "This is the book title page too."}
        book_delete_filter = Book.objects.filter(title="Glass Sword")
        delete_a_book = self.client.delete(f'/api/books/{book_delete_filter.pk}')
        self.assertEqual(delete_a_book.status_code, status.HTTP_200_OK)
        deletedbook = Book.objects.filter(title="Glass Sword")
        response = self.client.get(f'/api/books/{delete_a_book}')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertEqual(len(deletedbook), 0)

# content="A hobbit is a small human-like creature that lives in a hole in the ground. They are very peaceful and like to eat and drink."

# http://localhost:8000/api/admin/login/?next=/api/admin/