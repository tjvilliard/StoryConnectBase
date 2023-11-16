from sentence_transformers import SentenceTransformer, util
import numpy as np
import nltk
from nltk.tokenize import sent_tokenize
from books.models import Book
from ai_features.models import StatementSheet

def run():
    # Load the model
    model = SentenceTransformer('all-MiniLM-L6-v2')
    nltk.download('punkt')

    # # Your text and inconsistencies
    # text = ("Alice was beginning to get very tired of sitting by her sister on the bank, "
    #         "and of having nothing to do: once or twice she had peeped into the book her sister was reading, "
    #         "but it had no pictures or conversations in it, 'and what is the use of a book,' thought Alice "
    #         "'without pictures or conversation?' Suddenly, Alice noticed a white rabbit with pink eyes run close by her. "
    #         "The rabbit stopped and stared at her with beady blue eyes.")
    # inconsistencies = ["rabbit with blue eyes"]

    dgray, created = Book.objects.get_or_create(title="Dorian Gray")

   
    with(open("ai_features/demo/grey.txt", "r")) as f:
        text = f.read()

    with(open("ai_features/demo/grey_state_con.txt", "r")) as f, open("ai_features/demo/grey_statements.txt", "r") as f2:
        ss_con = StatementSheet(book=dgray, document=f.read())
        ss_og = StatementSheet(book=dgray, document=f2.read())

    ## EDITABLE CODE+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    targets = ss_og.get_character_statements("Basil-Hallward").strip().split("\n")




    ##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    # Split the text into sentences and store their offsets
    offsets = []
    start = 0
    sentences = []
    for sentence in sent_tokenize(text):
        start = text.find(sentence, start)
        end = start + len(sentence)
        offsets.append((start, end))
        sentences.append(sentence)
        start = end

    # Encode sentences & inconsistency
    sentence_embeddings = model.encode(sentences, convert_to_tensor=True)
    inconsistency_embeddings = model.encode(targets, convert_to_tensor=True)


    # print(targets)
    # print(inconsistency_embeddings.shape)
    # Find the closest sentences for each inconsistency
    for target, inconsistency_embedding in zip(targets, inconsistency_embeddings):
        cos_scores = util.pytorch_cos_sim(inconsistency_embedding, sentence_embeddings)[0]
        cos_scores = cos_scores.cpu()

        # We use np.argmax to find the highest scoring sentence
        top_result = np.argsort(cos_scores).tolist()[-1:-6:-1]
        print("Inconsistency:", target)
        for x, i in zip(top_result, range(5)):
            print(f"{i} similar sentence:", sentences[x])
            print("Similarity score:", cos_scores[x].item())
        # print("Offset in original text: Start =", offsets[top_result][0], ", End =", offsets[top_result][1])
        print('\n')


    


        