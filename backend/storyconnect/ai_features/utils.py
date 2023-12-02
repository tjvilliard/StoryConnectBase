import openai
from storyconnect.settings import OPENAI_API_KEY
import books.models as books_models
import ai_features.models as ai_models
import logging
from openai import OpenAI

logger = logging.getLogger(__name__)

openai.api_key = OPENAI_API_KEY

BASE_MODEL = "gpt-3.5-turbo-instruct"
CHAT_MODEL = "gpt-3.5-turbo-1106"
CHAT_MODEL_SMALL = "gpt-3.5-turbo" # for narrative elem
MAX_TOKENS = 2000
TEMPERATURE = 0.5
TEMP = 1.0 # for narrative elem 
MAX_CONTEXT = 16000
AVG_TOKEN = 3.5

## CC utils

def fill_book_sheet(cc, book, s_sheet, cur_ch_num):
        
        
        for i in range(s_sheet.last_run_chapter + 1, cur_ch_num):
            ch_curr = books_models.Chapter.objects.filter(book=book, chapter_number=i).first()
            
            new_text = ch_curr.content
            new_sheet = cc.create_statementsheet(new_text)
            logger.info(new_sheet)
            s_sheet.merge_sheets(new_sheet)
        
        s_sheet.last_run_chapter = cur_ch_num - 1
        s_sheet.last_run_offset = 0
        s_sheet.save()
        return s_sheet

## RU utils 
def summarize_chapter(
    chapter_id, model=BASE_MODEL, max_tokens=MAX_TOKENS, temp=TEMPERATURE
):
    """Summarizes a chapter using the BASE_MODEL. Stores in ChapterSummary table.
    Returns the summary as a string."""

    chapter = books_models.Chapter.objects.get(pk=chapter_id)
    prompt = "Summarize the following text:\n\n"
    prompt += chapter.content

    with open("ai_features/test_files/test_prints.txt", "w") as f:
        f.write(prompt)

    # If the chapter is too long, split it into two prompts
    context_length = len(prompt) / 3.5
    do_two_prompts = False
    if context_length > MAX_CONTEXT / 2:
        # do prompt 2 first so we dont overwrite prompt
        prompt2 = (
            "Summarize the following text\n\n"
            + prompt[int(MAX_CONTEXT / 2 * 3) : int(MAX_CONTEXT / 2 * 6)]
        )
        prompt = prompt[: int(MAX_CONTEXT / 2 * 3)]

        if len(prompt2) / AVG_TOKEN > (MAX_CONTEXT / 4):
            do_two_prompts = True
            prompt2 = prompt2[: int(MAX_CONTEXT / 2 * 3)]
            response2 = openai.Completion.create(
                model=model, prompt=prompt2, temperature=temp, max_tokens=max_tokens
            )

    # get the first summary no matter what
    response = openai.Completion.create(
        model=model,
        prompt=prompt,  # prompt is fine or truncated
        temperature=temp,
        max_tokens=max_tokens,
    )

    if do_two_prompts:
        # Combine the two summaries for the split chapter
        prompt3 = (
            "Combine the following two summaries:\n\n"
            + response.choices[0]["text"]
            + "\n\n"
            + response2.choices[0]["text"]
        )
        final_response = openai.Completion.create(
            model=model, prompt=prompt3, temperature=temp, max_tokens=max_tokens
        )
        summary = final_response.choices[0]["text"]
    else:
        # get the one summary
        summary = response.choices[0]["text"]

    # return the appropriate summary
    # logger.info(do_two_prompts)
    # logger.info(len(summary))
    # logger.info(summary)
    # logger.info(response.choices)
    # logger.info(response2.choices)
    # logger.info(final_response.choices)
    return summary


def summarize_chapter_chat(
    chapter_id, model=BASE_MODEL, max_tokens=MAX_TOKENS, temp=TEMPERATURE
):
    """Summarizes a chapter using the BASE_MODEL. Stores in ChapterSummary table.
    Returns the summary as a string."""

    chapter = books_models.Chapter.objects.get(pk=chapter_id)
    prompt = "Summarize the following text:\n\n"
    prompt += chapter.content

    with open("ai_features/test_files/test_prints.txt", "w") as f:
        f.write(prompt)

    # If the chapter is too long, split it into two prompts
    context_length = len(prompt) / 3.5
    do_two_prompts = False
    client = OpenAI(api_key=OPENAI_API_KEY)

    if context_length > MAX_CONTEXT / 2:
        # do prompt 2 first so we dont overwrite prompt
        prompt2 = (
            "Summarize the following text\n\n"
            + prompt[int(MAX_CONTEXT / 2 * 3) : int(MAX_CONTEXT / 2 * 6)]
        )
        prompt = prompt[: int(MAX_CONTEXT / 2 * 3)]

        if len(prompt2) / AVG_TOKEN > (MAX_CONTEXT / 4):
            do_two_prompts = True
            prompt2 = prompt2[: int(MAX_CONTEXT / 2 * 3)]
            response2 = client.chat.completions.create(
                model=CHAT_MODEL,
                messages=[{"role": "system", "content": prompt2}],
                temperature=temp,
                max_tokens=max_tokens,
                timeout=300,
            )

    # get the first summary no matter what
    response = client.chat.completions.create(
        model=CHAT_MODEL,
        messages=[{"role": "system", "content": prompt}],
        temperature=temp,
        max_tokens=max_tokens,
        timeout=300,
    )

    if do_two_prompts:
        # Combine the two summaries for the split chapter
        prompt3 = (
            "Combine the following two summaries:\n\n"
            + response.choices[0].message.content
            + "\n\n"
            + response2.choices[0].message.content
        )
        final_response = client.chat.completions.create(
            model=CHAT_MODEL,
            messages=[{"role": "system", "content": prompt3}],
            temperature=temp,
            max_tokens=max_tokens,
            timeout=300,
        )
        summary = final_response.choices[0].message.content
    else:
        # get the one summary
        summary = response.choices[0].message.content

    # return the appropriate summary
    # logger.info(do_two_prompts)
    # logger.info(len(summary))
    # logger.info(summary)
    # logger.info(response['choices'])
    # if do_two_prompts:
    #     logger.info(response2['choices'])
    #     logger.info(final_response['choices'])
    return summary


def summarize_book_chapters(book_id):
    """Gets or creates a summary for each chapter. Returns a dictionary of ch num : summary"""

    summary_dict = {}

    book = books_models.Book.objects.get(pk=book_id)
    for chapter in book.get_chapters():
        # ChapterSummary generates ai summary on creation
        ch_sum, created = ai_models.ChapterSummary.objects.get_or_create(
            chapter=chapter
        )
        summary_dict[chapter.chapter_number] = ch_sum.summary

    return summary_dict


def compile_book_summary(
    bk_sum, ch_sum_dict, model=BASE_MODEL, max_tokens=MAX_TOKENS, temp=TEMPERATURE
):
    """Compiles a book summary from a dictionary of chapter summaries. Updates the book summary in the database.
    param bk_sum: BookSummary object
    param ch_sum_dict: Dictionary of chapter summaries
    param model: OpenAI model to use
    param max_tokens: Max tokens to use
    param temp: Temperature to use
    Returns the compiled book summary as a string
    """

    # last summarized chapter number
    last_ch_num = bk_sum.last_sum_chapter

    new_book_sum = bk_sum.summary

    for i in range(last_ch_num + 1, len(ch_sum_dict)):
        prompt = f"Here is a summary of a book:\n\n{new_book_sum}\n\nHere is a summary of the next chapter:\n\n{ch_sum_dict[i]}\n\nCreate a new summary of the book that includes information from the new chapter."
        gpt_response = openai.Completion.create(
            model=model,
            prompt=prompt,
            max_tokens=max_tokens,
            temperature=temp,
            timeout=300,
        )
        new_book_sum = gpt_response.choices[0]["text"]

    # Update book summary and last ch included in summary
    bk_sum.summary = new_book_sum
    bk_sum.last_sum_chapter = len(ch_sum_dict) - 1
    return bk_sum.summary


def compile_book_summary_chat(
    bk_sum, ch_sum_dict, model=BASE_MODEL, max_tokens=MAX_TOKENS, temp=TEMPERATURE
):
    """Compiles a book summary from a dictionary of chapter summaries. Updates the book summary in the database.
    param bk_sum: BookSummary object
    param ch_sum_dict: Dictionary of chapter summaries
    param model: OpenAI model to use
    param max_tokens: Max tokens to use
    param temp: Temperature to use
    Returns the compiled book summary as a string
    """

    # last summarized chapter number
    last_ch_num = bk_sum.last_sum_chapter

    new_book_sum = bk_sum.summary
    client = OpenAI(api_key=OPENAI_API_KEY)

    for i in range(last_ch_num + 1, len(ch_sum_dict)):
        prompt = f"Here is a summary of a book:\n\n{new_book_sum}\n\nHere is a summary of the next chapter:\n\n{ch_sum_dict[i]}\n\nCreate a new summary of the book that includes information from the new chapter."
        gpt_response = client.chat.completions.create(
            model=CHAT_MODEL,
            messages=[{"role": "system", "content": prompt}],
            max_tokens=max_tokens,
            temperature=temp,
            timeout=300,
        )
        new_book_sum = gpt_response.choices[0].message.content

    # Update book summary and last ch included in summary
    bk_sum.summary = new_book_sum
    bk_sum.last_sum_chapter = len(ch_sum_dict) - 1
    return bk_sum.summary


def summarize_book(book_id):
    """Summarizes a book using the BASE_MODEL. Stores in BookSummary table"""

    # get or create bk sum model
    book = books_models.Book.objects.get(pk=book_id)
    bk_sum, created = ai_models.BookSummary.objects.get_or_create(book=book)

    ## Compile book summary should work for both new and existing book summaries
    # get or create all chapter summaries
    summary_dict = summarize_book_chapters(book_id=book.id)

    # compile chapter summaries into book summary
    bk_summary_text = compile_book_summary(bk_sum=bk_sum, ch_sum_dict=summary_dict)

    # return the summary and created info
    return bk_summary_text, created


def summarize_book_chat(book_id):
    """Summarizes a book using the CHAT_MODEL. Stores in BookSummary table"""

    # get or create bk sum model
    book = books_models.Book.objects.get(pk=book_id)
    bk_sum, created = ai_models.BookSummary.objects.get_or_create(book=book)

    ## Compile book summary should work for both new and existing book summaries
    # get or create all chapter summaries
    summary_dict = summarize_book_chapters(book_id=book.id)

    # compile chapter summaries into book summary
    bk_summary_text = compile_book_summary_chat(bk_sum=bk_sum, ch_sum_dict=summary_dict)

    # return the summary and created info
    return bk_summary_text, created


## Narrative element generation

client = OpenAI(api_key=OPENAI_API_KEY)

def generate_elements_from_statementsheet(user, s_sheet):
    """ Generates narrative elements for each type in a statement sheet. Returns a list of generated elements."""

    
    types = s_sheet.get_enitity_types()

    for e_type in types:
        # For each type, get or create a narrative element type for
        e_type_obj, created = books_models.NarrativeElementType.objects.get_or_create(user=user, name=e_type)
        # TODO: FINISH FROM elements_from_type
        elements_from_type(user, e_type_obj, s_sheet)

    return books_models.NarrativeElement.objects.filter(book=s_sheet.book)

def elements_from_type(user, e_type_obj, s_sheet):
    """ Generates all narrative elements of e_type in s_sheet. Returns a list of generated elements."""
    type_elems = s_sheet.get_tag_entities(e_type_obj.name)

    for t_elem in type_elems:
        elem_obj, created = books_models.NarrativeElement.objects.get_or_create(user=user, name=t_elem, element_type=e_type_obj, book=s_sheet.book)
        if created:
            # Set element description
            elem_obj.description = element_description(elem_obj, s_sheet)
        
        # Generate element attributes, outside of if statement so that they are always updated
        generate_attributes(elem_obj, s_sheet)


def element_description(elem_obj, s_sheet):
    """ Generates a description for a narrative element. Returns a string description."""
    elem_statements = s_sheet.get_statements(entity=elem_obj.name)

    prompt = f"{elem_obj.name} is a {elem_obj.element_type.name} in a story. \n {elem_statements}\n Generate a short description of {elem_obj.name}."
    gpt_response = client.chat.completions.create(
            model=CHAT_MODEL_SMALL,
            messages=[{"role": "system", "content": prompt}],
            temperature=TEMP,
            timeout=300,
        )
    
    description = gpt_response.choices[0].message.content
    return description

def generate_attributes(elem_obj, s_sheet):
    """ Generates attributes for a narrative element. Generates Narrative Elemenet Attribute objects in db for elem_obj"""
    elem_statements = s_sheet.get_statements(entity=elem_obj.name)

    prompt = f"{elem_obj.name} is a {elem_obj.element_type.name} in a story. \n {elem_statements}\n Give me a list of attibutes that describe {elem_obj.name}. Identify whether they are physical, personality, or background traits. Give a confidence measure for each trati. Example: Physical - Blonde Hair - 100"
    gpt_response = client.chat.completions.create(
            model=CHAT_MODEL_SMALL,
            messages=[{"role": "system", "content": prompt}],
            temperature=TEMP,
            timeout=300, 
        )
    
    attr_response = gpt_response.choices[0].message.content
    attr_tuple_list = parse_attributes(attr_response)

    for t in attr_tuple_list:
        attr_type_obj, type_created = books_models.NarrativeElementAttributeType.objects.get_or_create(user=elem_obj.user, name=t[0], applicable_to=elem_obj.element_type)
        attr_obj, attr_created = books_models.NarrativeElementAttribute.objects.get_or_create(element=elem_obj, attribute=t[1], attribute_type=attr_type_obj, confidence=t[2], generated=True)

    # Return for testing purposes
    return attr_response, attr_tuple_list
   

def parse_attributes(attr_response):
    """ Parses the attributes from the response from the generate_attributes function.
    Returns list of tuples of the form (attr_type, attr, confidence)"""
    attr_response = attr_response.split("\n")

    attr_list = []
    for line in attr_response:
        line = line.split("-")
        logger.info(line)
        attr_type = line[0].strip()
        attr = line[1].strip()
        confidence = line[2].strip()
        # confidence = confidence[:-1]
        # confidence = int(confidence)
        attr_list.append((attr_type, attr, confidence))


    return attr_list