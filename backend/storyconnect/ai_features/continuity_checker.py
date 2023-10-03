import openai
from storyconnect.settings import OPENAI_API_KEY
from .exceptions import *
from .models import StatementSheet
import logging
import lxml.etree as etree

openai.api_key = OPENAI_API_KEY

class ContinuityChecker:

    # openai parameters
    BASE_MODEL = "gpt-3.5-turbo-instruct"
    CHAT_MODEL = "gpt-3.5-turbo"
    MAX_TOKENS = 512
    TEMPERATURE = 0.2

    # continuity statement parameters
    stmt_task = "Generate a number of simple statements about each named entity in the text that are directly supported by the text. The statements only describe the named entities and do not describe actions within the text."
    stmt_instructions = "Format the response in XML, the first chunk will be for characters and the second will be for places. The header for each subsection is the entity's name, and what follows are the statements about the entities. The statements must start with the entity's name and not a pronoun. If the entity is more than one word, replace the space with a hyphen in the element tag."
    stmt_ex = "<Characters>\n<John-Doe>\nJohn Doe has blue eyes.\nJohn Doe is tall.\n</John-Doe>\n<Jane-Doe>\nJane Doe has blonde hair.\nJane Doe is 23 years old.\n</Jane-Doe>\n</Characters>\n<Locations>\n<New-York>\nNew York is a city.\nNew York is in the United States.\n</New-York>\n\n</Locations>"

    # continuity comparison parameters
    
    last_response = None


    @staticmethod
    def _statement_prompt(text):
        return f"Text: {text}\n\nTask: {ContinuityChecker.stmt_task}\n\nInstructions: {ContinuityChecker.stmt_instructions}\n\n Example: \n{ContinuityChecker.stmt_ex}"
    
    
    def create_statementsheet(self, text):
        if text == "":
            raise ContinuityCheckerNullTextError()
        
        
        prompt = ContinuityChecker._statement_prompt(text)
        self.last_response = openai.Completion.create(model = self.MODEL,
                                                prompt = prompt,
                                                max_tokens = self.MAX_TOKENS,
                                                temperature = self.TEMPERATURE,
                                                )

        body = self.last_response['choices'][0]['text']
        
        formatted_text = "<Statements>\n" + body.strip() + "\n</Statements>"
        return formatted_text
    
    def compare_statementsheets(self, s_old, s_new):
        s_old = ContinuityChecker.strip_xml(s_old)
        s_new = ContinuityChecker.strip_xml(s_new)

        # print(s_old)
        # print('\n')
        # print(s_new)
        comp_input = f"The following statements are about previously written text: \n {s_old} \n The following statements are about new text: \n {s_new}\n"
        comp_instructions = "Identify any contradictions between the old text and the new text. Do not list any contradictions that are not supported by the statements. Stop when appropriate."
        prompt = comp_input + comp_instructions
        
        self.last_response = openai.Completion.create(model = self.BASE_MODEL,
                                                      prompt = prompt,
                                                        max_tokens = self.MAX_TOKENS ,
                                                        temperature = self.TEMPERATURE * 5,
        )
        
        return self.last_response['choices'][0]['text'].strip()

    @staticmethod
    def strip_xml(text):
        tree = etree.fromstring(text)
        
        statements = ""
        for child in tree:
            for subchild in child:
                statements += subchild.text.strip()

        return statements