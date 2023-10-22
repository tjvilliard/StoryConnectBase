import openai
from storyconnect.settings import OPENAI_API_KEY
import books.models as books_models
import ai_features.models as ai_models
import logging

logger = logging.getLogger(__name__)

openai.api_key = OPENAI_API_KEY

BASE_MODEL = "gpt-3.5-turbo-instruct"
CHAT_MODEL = "gpt-3.5-turbo"
MAX_TOKENS = 512
TEMPERATURE = 0.2

def summarize_chapter(chapter_id, model=BASE_MODEL, max_tokens=MAX_TOKENS, temp=TEMPERATURE):
    """Summarizes a chapter using the BASE_MODEL. Stores in ChapterSummary table"""

    chapter = books_models.Chapter.objects.get(pk=chapter_id)
    prompt = "Summarize the following text:\n\n"
    prompt += chapter.content

    response = openai.Completion.create(model = model,
                                        prompt = prompt,
                                        max_tokens = max_tokens,
                                        temperature = temp,
                                        )
    summary = response.choices[0]['text']
    return summary

def summarize_book_chapters(book_id):
    """Gets or creates a summary for each chapter. Returns a dictionary of ch num : summary"""

    summary_dict = {}

    book = books_models.Book.objects.get(pk=book_id)
    for chapter in book.get_chapters():
        # ChapterSummary generates ai summary on creation 
        ch_sum, created = ai_models.ChapterSummary.get_or_create(chapter=chapter)
        summary_dict[chapter.chapter_number] = ch_sum.summary

    return summary_dict

def compile_book_summary(bk_sum, ch_sum_dict, model=BASE_MODEL, max_tokens=MAX_TOKENS, temp=TEMPERATURE):
    """Compiles a book summary from a dictionary of chapter summaries. Updates the book summary in the database."""

    #last summarized chapter number
    last_ch_num = bk_sum.last_sum_chapter

    new_book_sum = bk_sum.summary

    for i in range(last_ch_num + 1, len(ch_sum_dict)):
        prompt = f"Here is a summary of a book:\n\n{new_book_sum}\n\nHere is a summary of the next chapter:\n\n{ch_sum_dict[i]}\n\nCreate a new summary of the book that includes information from the new chapter."
        gpt_response = openai.Completion.create(model = model,
                                                prompt = prompt,
                                                max_tokens = max_tokens,
                                                temperature = temp,
                                                )
        new_book_sum = gpt_response.choices[0]['text']
    
    # Update book summary and last ch included in summary
    bk_sum.summary = new_book_sum
    bk_sum.last_sum_chapter = len(ch_sum_dict) - 1
    return bk_sum.summary
    

def summarize_book(book_id):
    """Summarizes a book using the BASE_MODEL. Stores in BookSummary table"""

    # get or create bk sum model
    book = books_models.Book.objects.get(pk=book_id)
    bk_sum, created = ai_models.BookSummary.get_or_create(book=book)

    ## Compile book summary should work for both new and existing book summaries
    # get or create all chapter summaries
    summary_dict = summarize_book_chapters(book_id=book.id)
    # compile chapter summaries into book summary
    bk_summary = compile_book_summary(bk_sum=bk_sum, ch_sum_dict=summary_dict)
    

    # return the summary and created info
    return bk_summary, created
