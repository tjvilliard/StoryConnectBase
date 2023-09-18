from books.models import *
from django.db.models import Count


def general_rec():
#     all_books_in_reading = Library.objects.all(status=1)

#     trending_books = {}
#     for b in all_books_in_reading:
#         book_id = b.book.pk
    books_count = Library.objects.filter(status=1,).order_by('book').values('book__pk').annotate(count=Count('book__name'))
    books_count_dict = {books_count['book__pk']: books_count['count'] for f in trending_books}
    # [{'count': 3, 'category__name': u'category1'}, {'count': 1, 'category__name': u'category2'}]

    trending_books = sorted(books_count_dict.items(),key=lambda x:x[1], reverse=True)[0:20]
    trending_books_dict = dict(trending_books)

    trending_books_objects = []
    for book in trending_books_dict.values():
        tr_book = Book.objects.get(pk = book)
        trending_books_objects.append(tr_book)

    return trending_books_objects

def personal_rec(user_id):
    personal_books_in_library = Library.objects.filter(reader=User.objects.get(id=user_id))
    

