import openai 
from storyconnect.settings import OPENAI_API_KEY
from .exceptions import *
import books.models as books_models
import ai_features.models as ai_models
import ai_features.utils as utils
import logging

openai.api_key = OPENAI_API_KEY

class RoadUnblocker():
    # openai parameters
    BASE_MODEL = "gpt-3.5-turbo-instruct"
    CHAT_MODEL = "gpt-3.5-turbo-16k"
    MAX_TOKENS = 5000
    TEMPERATURE = 0.2

    SYS_ROLE = "You are an AI writing assistant. You are helping a writer write a story. You are not a writer yourself, but you are very good at helping."
    PRE_MESSAGE = "Hello! I am Road Unblocker. Your personal AI writing assistant. I am here to help you write your story."

    def __init__(self):
        self.last_response = None
        self.sys_message = [{"role": "system", "content": self.SYS_ROLE},]
        

    # def _summarize_chapter(self, chapter_id):
    #     """Summarizes a chapter using the BASE_MODEL. Stores in ChapterSummary table"""

    #     chapter = books_models.Chapter.objects.get(pk=chapter_id)
    #     prompt = "Summarize the following text:\n\n"
    #     prompt += chapter.content

    #     response = openai.Completion.create(model = self.BASE_MODEL,
    #                                        prompt = prompt,
    #                                        max_tokens = self.MAX_TOKENS,
    #                                        temperature = self.TEMPERATURE,
    #                                        )
    #     summary = response.choices[0]['text']
    #     return summary
    
    # def _summarize_book(self, book_id):
    #     """Summarizes a book using the BASE_MODEL. Stores in BookSummary table"""

    #     running_summary = ""

    #     book = books_models.Book.objects.get(pk=book_id)
    #     for chapter in book.get_chapters():
    #         ch_sum, created = ai_models.get_or_create_chapter_summary(chapter=chapter)
    #         if created:
    #             ch_sum.summary = self._summarize_chapter(chapter.id)
    #             ch_sum.save()

    #         running_summary += ch_sum.summary + "\n"

    #     response = openai.Completion.create(model = self.BASE_MODEL,
    #                                        prompt = prompt,
    #                                        max_tokens = self.MAX_TOKENS,
    #                                        temperature = self.TEMPERATURE,
    #                                        )
    #     summary = response.choices[0]['text']
    #     return summary

    def _generate_context(self, chapter_id):
        chapter = books_models.Chapter.objects.get(pk=chapter_id)
        book = chapter.book
        
        bk_chapters = book.get_chapters()

        messages = [self.sys_message,]

        # include summary only if more than one chapter
        if bk_chapters.count() > 1:
            u_msg_summary = "Here is a summary of my book so far:\n\n"
            
            # TODO: Remember that this is now chat model
            u_msg_summary += utils.summarize_book_chat(book.id)
            messages.append({"role": "user", "content": u_msg_summary})
        
        # include chapter content
        u_msg_chapter = "Here is the content of the chapter you are working on:\n\n"
        u_msg_chapter += chapter.content
        messages.append({"role": "user", "content": u_msg_chapter})

        return messages




        

    def get_suggestions(self, question, chapter_id):
        messages = self._generate_context(chapter_id)
        messages.append({"role": "user", "content": question})
        self.last_response = openai.ChatCompletion.create(model = self.CHAT_MODEL,
                                                          messages = messages,
                                                          max_tokens = self.MAX_TOKENS
                                                          )
        # returns first suggestion
        # TODO: handle multiple suggestions, serializer and front end give multi suggest not chat bubble
        response_content = self.last_response.choices[0]['message']['content']
        
        return response_content
