from books.models import *
import csv
import sys

def integrate_books(csvfile):

    maxInt = sys.maxsize

    while True:
        # decrease the maxInt value by factor 10 
        # as long as the OverflowError occurs.

        try:
            csv.field_size_limit(maxInt)
            break
        except OverflowError:
            maxInt = int(maxInt/10)

    with open(csvfile, "r") as file:
        csvf = csv.reader(file)
        user_owner, created = User.objects.get_or_create(id=11)
        for row in csvf:
            # print(row[0])
            Book.objects.get_or_create(
                title=row[3],
                user=user_owner,
                language='English',
                target_audience=1,
                tags=[row[2]],
                synopsis=row[0],
            )


# csvf = read_csv("booktesting7.csv")
def run():
    integrate_books("scripts/bookdesc_datacleaned.csv")
