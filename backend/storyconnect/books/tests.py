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

        # Book.objects.create(title= "Demo item 2",description= "This is a description for demo 2",price= 700,stock= 15)

        # self.items = Book.objects.all()

        # create user
        self.user = User.objects.create_user(
            username='testuser1', 
            password='this_is_a_test',
            email='testuser1@test.com'
        )
        # create a book for the user
        self.userbook = Book.objects.create(
            title = "Red Queen", 
            author = "Victoria Aveyard", 
            owner = self.user,
            language = 1,
            target_audience = 1,
            synopsis = "This is the book synopsis.",
            copyright = 1, 
            titlepage = "This is the book title page.")
        

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
        self.assertEqual(Book.objects.count(), 2)
        response = self.client.get('/books/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        
    # testing perform query to only show the author's books
    def test_author_all_books(self):
        authorbooks = Book.objects.filter(owner = self.user)
        for b in authorbooks:
            response = self.client.get(f'/books/{b.owner}/') # not sure
            self.assertEqual(response.status_code, status.HTTP_200_OK)                           
    
    def test_a_book_property(self):
        response = self.client.get(f'/books/{self.userbook}')
        self.assertEqual(response.status_code, status.HTTP_200_OK)                           
        self.assertEqual(Book.objects.get().__getattribute__(), 'to be made')

    def test_getting_book_properties(self):

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
        response = self.client.get(f'/books/{dune}')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        
content="A hobbit is a small human-like creature that lives in a hole in the ground. They are very peaceful and like to eat and drink."