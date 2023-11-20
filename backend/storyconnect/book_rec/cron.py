from models import *
from books.models import *

def rating_cron_job():
    all_books = Book.objects.all()

    for the_book in all_books:
        the_book_rate, created = Book_Rating.objects.get_or_create(book=the_book)
        book_rate = the_book_rate.get_rating()
        the_book_rate.rating = book_rate

        Book_Rating.objects.update(book=the_book_rate, rating=book_rate)
    
