import openai
from .exceptions import *
from .models import StatementSheet

class ContinuityChecker:

    # openai parameters
    MODEL = "gpt-3.5-turbo-instruct"
    MAX_TOKENS = 512
    TEMPERATURE = 0.2

    # continuity checker prompt values
    # Text = ""
    Task = "Generate a number of simple statements about each named entity in the text that are directly supported by the text. The statements only describe the named entities and do not describe actions within the text."
    Instructions = "Format the response in XML, the first chunk will be for characters and the second will be for places. The header for each subsection is the entity's name, and what follows are the statements about the entities. The statements must start with the entity's name and not a pronoun. If the entity is more than one word, replace the space with a hyphen in the element tag."
    Example = "<Characters>\n<John-Doe>\nJohn Doe has blue eyes.\nJohn Doe is tall.\n</John-Doe>\n<Jane-Doe>\nJane Doe has blonde hair.\nJane Doe is 23 years old.\n</Jane-Doe>\n</Characters>\n<Locations>\n<New-York>\nNew York is a city.\nNew York is in the United States.\n</New-York>\n\n</Locations>"

    def generate_prompt(self, text):
        return f"Text: {text}\n\nTask: {self.Task}\n\nInstructions: {self.Instructions}\n\n Example: \n{self.Example}"
    
    def create_statementsheet(self, text):
        if text == "":
            raise ContinuityCheckerNullTextError()
        
        prompt = self.generate_prompt(text)
        gpt_response = openai.Completion.create(model = self.MODEL,
                                                prompt = prompt,
                                                max_tokens = self.MAX_TOKENS,
                                                temperature = self.TEMPERATURE,
                                                )

        body = gpt_response['choices'][0]['text']
        
        formatted_text = "<Statements>\n" + body + "\n</Statements>"
        return formatted_text
    
    
        

        
