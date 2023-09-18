# import django
# from django.conf import settings


# settings.configure(default_settings='storyconnect.settings', DEBUG=True)
# django.setup()


from books.models import *
import csv


def integrate_books(csvfile):

    with open(csvfile, 'r') as file:
        csvf= csv.reader(file)
        user_owner,created = User.objects.get_or_create(id=3)
        for row in csvf:
            Book.objects.get_or_create(
            title = row[0],
            author = row[1],
            owner = user_owner,
            language = row[3],
            target_audience = row[4],
            book_status = row[5],
            tags = [row[6]],
            cover = row[7],
            created = "2023-09-16",
            modified = "2023-09-16",
            synopsis = row[10],
            copyright = row[11],
            titlepage = row[12]
        )

# csvf = read_csv("booktesting7.csv")
def run():
    integrate_books("/src/scripts/booktesting7.csv")
