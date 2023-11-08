from django.test import TestCase
from .models import *
from books.models import Book
from .continuity_checker import ContinuityChecker
from .road_unblocker import RoadUnblocker
import ai_features.utils as utils
import logging
# Create your tests here.
class StatementSheetTests(TestCase):
    def setUp(self):
        self.book = Book.objects.create(title="Test Book")
        self.document = "<Statements>\n<Characters>\n<John-Doe>John Doe has blue eyes.\nJohn Doe is tall.\n</John-Doe>\n<Jane-Doe>Jane Doe has blonde hair.\nJane Doe is 23 years old.\n</Jane-Doe>\n</Characters>\n<Locations>\n<New-York>New York is a city.\nNew York is in the United States.\n</New-York>\n\n</Locations>\n</Statements>"
        self.new_document = "<Statements>\n<Characters>\n<John-Doe>John Doe has the upper hand.\n</John-Doe>\n</Characters>\n<Locations>\n<Kings-Landing>Kings Landing is the capital of the Westeros.\n</Kings-Landing>\n</Locations>\n</Statements>"
        self.sheet = StatementSheet.objects.create(book=self.book, document=self.document)
    
    def test_get_characters(self):
        characters = self.sheet.get_characters()
        self.assertEqual(characters, ['John-Doe', 'Jane-Doe'])

    def test_get_character_statements(self):
        statements = self.sheet.get_character_statements('John-Doe')
        self.assertEqual(statements, 'John Doe has blue eyes.\nJohn Doe is tall.\n')
    
    def test_get_locations(self):
        locations = self.sheet.get_locations()
        self.assertEqual(locations, ['New-York'])
    
    def test_get_location_statements(self):
        statements = self.sheet.get_location_statements('New-York')
        self.assertEqual(statements, 'New York is a city.\nNew York is in the United States.\n')
    
    def test_merge_sheets(self):
        self.sheet.merge_sheets(self.new_document)

        locations = self.sheet.get_locations()
        self.assertEqual(locations, ['New-York', 'Kings-Landing'])

        statements = self.sheet.get_character_statements('John-Doe')
        self.assertEqual(statements, 'John Doe has blue eyes.\nJohn Doe is tall.\nJohn Doe has the upper hand.\n')

class ContinuityCheckerTests(TestCase):
    def setUp(self):
        self.logger = logging.getLogger(__name__)

        self.cc = ContinuityChecker()
        self.text1 = """They met in The Kings Square, a quiet and peaceful spot at this time of night. Alexander and Isobel sat under the grand fountain, a statue of a forgotten ruler looking over them. Alexander looked longingly into Isobels dark sea-colored eyes, her dark auburn hair glistening as the sun falls behind her. He loved her
                        and she him. He let his hand fall against her burnished olive skin. It was warm to the touch. She received him well and 
                        looked back into his stark icy eyes. Isobel grabbed Alexander by his scruffy blonde curls and told him,
                        "never let me go". """
        self.text2 = """Isobel looked over at alexander, his eyes fixed on the sword in his hand, the brown of his eyes reflecting of the blade
                        and back at her. He was a man meant to hold a weapon. He wielded it delicately and yet commanded it ferociously. He 
                        raised the sword in his hand and as grabbed his ragged ponytail. In one motion the blade was through. He held out the 
                        clump of brown hair and let it drop to the floor. """
        
        self.sheet1 = """<Statements>
                            <Characters>
                            <Alexander>
                            Alexander has scruffy blonde curls.
                            Alexander has stark icy eyes.
                            </Alexander>
                            <Isobel>
                            Isobel has dark sea-colored eyes.
                            Isobel has dark auburn hair.
                            Isobel has burnished olive skin.
                            </Isobel>
                            </Characters>
                            <Locations>
                            <Kings-Square>
                            The Kings Square is a quiet and peaceful spot.
                            The Kings Square has a grand fountain.
                            The Kings Square has a statue of a forgotten ruler.
                            </Kings-Square>
                            </Locations>
                            </Statements>"""

        self.sheet2 = """<Statements>
                            <Characters>
                            <Alexander>
                            Alexander has brown eyes.
                            Alexander has a ragged ponytail.
                            </Alexander>
                            <Isobel>
                            Isobel has pail skin.
                            </Isobel>
                            </Characters>
                            </Statements>
                            """
 
    def test_api_call(self):
        cc_response = self.cc.create_statementsheet(self.text1)
        
        print('\n' + cc_response + '\n')
        print(self.cc.last_response)

    def test_comparison(self):
        cc_response = self.cc.compare_statementsheets(self.sheet1, self.sheet2)
        print(cc_response)
        # print("\n")
        # print(self.cc.last_response)

class RoadUnblockerTests(TestCase):
    def setUp(self):
        self.ru = RoadUnblocker()
        self.book = Book.objects.create(title="Test Book")
        self.chapter = Chapter.objects.create(book=self.book, chapter_number=1, content="This is the first chapter of the book.")

class UtilsTests(TestCase):
    def setUp(self):
        self.book = Book.objects.create(title="Dorian Gray")

        with open("ai_features/test_files/ch_1.txt", "r") as f1, open("ai_features/test_files/ch_2.txt", "r") as f2, open("ai_features/test_files/ch_3.txt", "r") as f3:
            self.chapter1 = Chapter.objects.create(book=self.book, content=f1.read())
            self.chapter2 = Chapter.objects.create(book=self.book, content=f2.read())
            self.chapter3 = Chapter.objects.create(book=self.book, content=f3.read())
        
    def test_summarize_chapter(self):

        with open("ai_features/test_files/ch_1_summary.txt", "w") as f:
            for ch in self.book.get_chapters():
                summary = utils.summarize_chapter_chat(ch.id)
                f.write(summary)
    
    def test_summarize_book_chapters(self):
        summary_dict = utils.summarize_book_chapters(self.book.id)
        with open("ai_features/test_files/chapters_summary.txt", "w") as f:
            for item in ChapterSummary.objects.all():
                f.write(str(item.chapter.chapter_number) + "\n" + item.summary + "\n")
    
    def test_summarize_book(self):
        # RETURNS A STRING AND BOOL
        bk_sum, created = utils.summarize_book(self.book.id)
        assert created == True
        assert bk_sum != ""
        with open("ai_features/test_files/book_summary.txt", "w") as f:
            f.write(bk_sum)
        


        
        
