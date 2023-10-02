from typing import Any
from django.db import models
from books.models import Chapter
from comment.models import TextSelection
from lxml import etree
import logging
# Create your models here.

class RoadUnblockerSuggestion(models.Model):
    '''Model that holds suggestion data generated using LLM.'''

    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE, related_name='road_unblocker_suggestions')

    suggestion = models.TextField(blank=True, null=True)

    suggestion_type = models.CharField(max_length=50, blank=True, null=True)


class StatementSheet(models.Model):
    """Model that holds the statements generated by the AI."""
    book = models.ForeignKey('books.Book', on_delete=models.CASCADE, related_name='statement_sheets')
    last_run_chapter = models.ForeignKey('books.Chapter', on_delete=models.CASCADE, null=True)
    last_run_offset = models.IntegerField(default=0)

    document = models.TextField(default="<Statements></Statements>")

    def __init__(self, *args: Any, **kwargs: Any) -> None:
        super().__init__(*args, **kwargs)
        self.s_tree = etree.fromstring(self.document)
        # self.logger = logging.getLogger(__name__)

    def get_characters(self):
        # selfs_tree = etree.fromstring(self.document)
        characters = [x.tag for x in list(self.s_tree[0])]
        return characters
    
    def get_character_statements(self, character):
        statements = ""

        for child in self.s_tree[0]:
            if child.tag == character:
                statements = child.text
                break

        return statements

    def get_locations(self):
        places = [x.tag for x in list(self.s_tree[1])]
        return places
    
    def get_location_statements(self, location):
        statements = ""

        for child in self.s_tree[1]:
            if child.tag == location:
                statements = child.text
                break

        return statements
    
    def merge_sheets(self, new_sheet):
        n_tree = etree.fromstring(new_sheet)

        existing_characters = self.get_characters()
        existing_locations = self.get_locations()

        for child in n_tree[0]:
            if child.tag not in existing_characters:
                self.s_tree[0].append(child)
            else:
                s_statements = self.get_character_statements(child.tag).split("\n")
                n_statements = child.text.split("\n")
                for n_statement in n_statements:
                    if n_statement not in s_statements:
                        s_statements.append(n_statement)
                
                join_statements = [x.strip() + "\n" for x in s_statements if x != "" and x != "\n" and x != " "]

                self.s_tree[0].find(child.tag).text = "".join(join_statements)
        
        for child in n_tree[1]:
            if child.tag not in existing_locations:
                self.s_tree[1].append(child)
            else:
                s_statements = self.get_location_statements(child.tag).split("\n")
                n_statements = child.text.split("\n")
                for n_statement in n_statements:
                    if n_statement not in s_statements:
                        s_statements.append(n_statement)
                
                join_statements = [x.strip() + "\n" for x in s_statements if x != "" and x != "\n" and x != " "]
                self.s_tree[1].find(child.tag).text = "".join(join_statements)
        
        self.document = etree.tostring(self.s_tree, pretty_print=True).decode('utf-8')