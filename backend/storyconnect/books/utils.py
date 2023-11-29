
from storyconnect.settings import OPENAI_API_KEY
import books.models as books_models
from ai_features.models import StatementSheet
# import ai_features.utils as ai_utils
import logging
from openai import OpenAI

logger = logging.getLogger(__name__)
client = OpenAI(api_key=OPENAI_API_KEY)
CHAT_MODEL = "gpt-3.5-turbo"
TEMP = 1.0

def generate_elements_from_statementsheet(user, s_sheet):

    types = s_sheet.get_enitity_types()

    for e_type in types:
        e_type_obj, created = books_models.NarrativeElementType.objects.get_or_create(user=user, name=e_type)
        # TODO: FINISH FROM elements_from_type
        elements_from_type(e_type_obj, s_sheet)

def elements_from_type(e_type_obj, s_sheet):
    type_elems = s_sheet.get_tag_entities(e_type_obj.name)

    for t_elem in type_elems:
        elem_obj, created = books_models.NarrativeElement.objects.get_or_create(user=user, name=t_elem, element_type=e_type_obj)
        if created:
            elem_obj.description = element_description(elem_obj, s_sheet)

        ## TODO: add statements to element

def element_description(elem_obj, s_sheet):
    elem_statements = s_sheet.get_statements(entity=elem_obj.name)

    prompt = f"{elem_obj.name} is a {elem_obj.element_type.name} in a story. \n {elem_statements}\n Generate a short description of {elem_obj.name}."
    gpt_response = client.chat.completions.create(
            model=CHAT_MODEL,
            messages=[{"role": "system", "content": prompt}],
            temperature=TEMP,
            timeout=300,
        )
    
    description = gpt_response.choices[0].message.content
    return description

def generate_attributes(elem_obj, s_sheet):
    elem_statements = s_sheet.get_statements(entity=elem_obj.name)

    prompt = f"{elem_obj.name} is a {elem_obj.element_type.name} in a story. \n {elem_statements}\n Give me a list of attibutes that describe {elem_obj.name}. Identify whether they are physical, personality, or background traits."
    gpt_response = client.chat.completions.create(
            model=CHAT_MODEL,
            messages=[{"role": "system", "content": prompt}],
            temperature=TEMP,
            timeout=300,
        )
    
    attr_list = gpt_response.choices[0].message.content

    return attr_list