from books.models import *
import csv
import sys

def integrate_chapters(csvfile):
    maxInt = sys.maxsize

    while True:
        # decrease the maxInt value by factor 10 
        # as long as the OverflowError occurs.

        try:
            csv.field_size_limit(maxInt)
            break
        except OverflowError:
            maxInt = int(maxInt/10)

    with open(csvfile, 'r') as file:
        csvf= csv.reader(file)
        for row in csvf:
            book_chapter,created = Book.objects.get_or_create(id=row[0])
            Chapter.objects.get_or_create(
                book = book_chapter,
                chapter_number = row[1],
                chapter_title = row[2],
                content = row[3]
            )
            
def run():
    integrate_chapters("/src/scripts/chapter_final_shorten.csv")