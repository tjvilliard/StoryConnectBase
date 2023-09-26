import pandas as pd
import requests
from datetime import datetime
from bs4 import BeautifulSoup
<<<<<<< HEAD
from .models import *
=======
from models import *
from typing import List, Dict
>>>>>>> feature/Creating_models

def data_collection():
    book = {}
    months = {'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12}
    # counter = 0
    # for i in range(1):
<<<<<<< HEAD
    url = "https://www.gutenberg.org/ebooks/search/?sort_order=downloads&start_index=0"
    r = requests.get(url)
    soup = BeautifulSoup(r.text, features="html.parser")
=======
    # url = "https://www.gutenberg.org/ebooks/search/?sort_order=downloads&start_index=0"
    # r = requests.get(url)
    # soup = BeautifulSoup(r.text, features="html.parser")
>>>>>>> feature/Creating_models

    # links = []
    # for line in soup.findAll('a', {'class': 'link'}):
    #     links.append(line.get('href'))
    ebook_lst = ['1550', '1553', '1554', '1556', '1557', '1563', '1565', '1569', '1573', '1585']
    for ebook_no in ebook_lst:
        # ebook_no = link.replace('/ebooks/', '')
        # ebook_no = link[8:]
        url2 = 'https://www.gutenberg.org/ebooks/'+ str(ebook_no)
        print(ebook_no)
        url_content = "https://www.gutenberg.org/cache/epub/" + ebook_no + "/pg" + ebook_no + ".txt"

        # print(url2)
        r = requests.get(url2)
        soup2 = BeautifulSoup(r.text, features="html.parser")

        # url_content = url2
        # url_content += ".txt.utf-8"
        r = requests.get(url_content)
        # soup3 = BeautifulSoup(r.text, features='html.parser')
        # context = ssl._create_unverified_context()

        # data = urlopen("https://www.gutenberg.org/cache/epub/" + str(int(ebook_no)) + "/pg" + str(int(ebook_no)) + ".txt",
        #                context=context).read().decode("utf-8")

        detail = {}

        detail['title'] = soup2.find(itemprop = 'headline').get_text().strip('\n')
        try:
            detail['author'] = soup2.find(itemprop = 'creator').get_text().strip('\n')
        except Exception as e:
            detail['author'] = '?'

        langs = []
        for lang in soup2.find(itemprop = 'inLanguage').findAll('td'):
            langs.append(lang.get_text())
        detail['language'] = langs

        subjs = []
        for subj in soup2.findAll('a', {'class':'block'}):
            subjs.append(subj.get_text('href').strip('\n').replace("-",""))
        detail['subject'] = subjs

        date = soup2.find(itemprop = 'datePublished').get_text().replace(',', '').split()
        month = months[date[0]]
        day = int(date[1])
        year = int(date[2])
        date_format = str(year) + '-' + str(month) + '-' + str(day)
        detail['released date'] = date_format

        # detail['released date'] = datetime.strptime(soup2.find(itemprop = 'datePublished').get_text().strip('\n'), '%d %b %Y')

        # detail['download number'] = soup2.find(itemprop = "interactionCount").get_text().strip('downloads in the last 30 days.')

        content = r.text
        book_content = filter_content(content)
        chapters = chapter_content(book_content)
        detail['chapteredcontent'] = chapters

        book[ebook_no] = detail
    
    create_book_chapters(book)
    # write_book_content(book)

    # df = pd.DataFrame(book)
    # df.to_csv("book500-1000.csv")

    return book

def filter_content(content):
    content_lst = content.split("***")
    content_lst = content_lst[2:-2]

    for i,c in enumerate(content_lst):
        content_lst[i] = ''.join(c.splitlines())
    content_lst = "".join(content_lst)
    return content_lst

def chapter_content(content):
    content_lst = list(content.split("CHAPTER"))
    return content_lst

def write_book_content(book):
    with open("bookcontenttesting.txt", "w") as file:
        for ebook_no in book:
            file.write(ebook_no + "|" + book[ebook_no]['title'] + "\n" + book[ebook_no]['content'] + "\n\n")

def create_book_chapters(book):
    for ebook in book:
        b = Book.objects.create(
            title = book[ebook]['title'],
            author = book[ebook]['author'],
            language = book[ebook]['language'],
            target_audience = 1,
            created = book[ebook]['released date'],
            synopsis = book[ebook]['title'],
            copyright = 1,
            titlepage = book[ebook]['title']
        )
        for i,ch in enumerate(ebook['chapteredcontent']):
            Chapter.objects.create(
                book = b,
                chapter_number = i,
                chapter_title = ebook['title'],
                content = ch
            )

<<<<<<< HEAD
book = data_collection()
=======
book = data_collection()
>>>>>>> feature/Creating_models