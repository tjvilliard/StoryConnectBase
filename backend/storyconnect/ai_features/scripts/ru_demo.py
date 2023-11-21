import ai_features.road_unblocker as ru

# with open("ai_features/test_files/ch_1.txt", "r") as f1, open("ai_features/test_files/ch_2.txt", "r") as f2, open("ai_features/test_files/ch_3.txt", "r") as f3:
#     chapter1 = f1.read()
#     chapter2 = f2.read()
#     chapter3 = f3.read()
# class RoadUnblockerTests(TestCase):
#     def setUp(self):
#         self.ru = RoadUnblocker()
#         self.book = Book.objects.create(title="Dorian Gray")

#         with open("ai_features/test_files/ch_1.txt", "r") as f1, open("ai_features/test_files/ch_2.txt", "r") as f2, open("ai_features/test_files/ch_3.txt", "r") as f3:
#             self.chapter1 = Chapter.objects.create(book=self.book, content=f1.read())
#             self.chapter2 = Chapter.objects.create(book=self.book, content=f2.read())
#             self.chapter3 = Chapter.objects.create(book=self.book, content=f3.read())
        
#     def test_get_suggestion(self):
#         question = "Do you have any suggestions for this chapter?"
#         selection = ""
#         suggestion = self.ru.get_suggestions(selection, question, self.chapter1.id)
        
#         print("Openning file....")
#         with open("ai_features/test_files/ru_suggestions.txt", "w") as f:
#             f.write(suggestion)
#         print("Done.")