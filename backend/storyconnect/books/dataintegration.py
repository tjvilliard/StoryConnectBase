import django
from django.conf import settings


settings.configure(default_settings='storyconnect.settings', DEBUG=True)
# django.setup()


from models import *
import csv


def integrate_books(csvfile):
    books = []
    with open(csvfile, 'r') as file:
        csvf= csv.reader(file)
        for row in csvf:
            obj, created = Book.objects.get_or_create(
            title = row[0],
            author = row[1],
            owner = row[2],
            language = row[3],
            target_audience = row[4],
            book_status = row[5],
            tags = row[6],
            cover = row[7],
            created = row[8],
            modified = row[9],
            synopsis = row[10],
            copyright = row[11],
            titlepage = row[12]
        )
    
    # book_res = Book.objects.bulk_create(books)


def integrate_chapters(all_chapter):
    # libraries = []
    chapters = []
    # scenes = []
    # locations = []
    # commentss = []

    for b in books:
        # lib = Library(
        #     book = b,
        #     status = 1,
        #     reader = 3
        # )
        # libraries.append(lib)
        ebooks = all_book.values()
        for ebook in ebooks:
            c = 1
            for ch in ebook['chapteredcontent']:
                chp = Chapter(
                    book = b,
                    chapter_number = c,
                    chapter_title = str(c),
                    chapter_content = ch[0]
                )
                chapters.append(chp)
                # sc = Scene(
                #     chapter = chp,
                #     scene_title = "",
                #     scene_content = ""
                # )
                # scenes.append(sc)
                # com = Comments(
                #     book = b,
                #     chapter = chp,
                #     commenter = 3,
                #     content = "hi"
                # )
                # commentss.append(com)
                c += 1

        # loc = Location(
        #     book = b,
        #     name = "",
        #     description = ""
        # )
        # locations.append(loc)  
    
    chapter_res = Chapter.objects.bulk_create(chapters)
    # library_res = Library.objects.bulk_create(libraries)
    # scene_res = Scene.objects.bulk_create(scenes)
    # location_res = Location.objects.bulk_create(location_res)
    # comment_res = Comments.objects.bulk_create(commentss)

def read_csv(csvfile):

    # opening the CSV file
    with open(csvfile, mode ='r') as file:   
            
        # reading the CSV file
        csvf= csv.DictReader(file)
    
        # # displaying the contents of the CSV file
        # for lines in csvf:
        #     print(lines)
    return csvf

# csvf = read_csv("booktesting7.csv")
def run():
    integrate_books("booktesting7.csv")
