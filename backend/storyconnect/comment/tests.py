from django.test import TestCase
from django.contrib.auth.models import User
from .managers import WriterFeedbackManager
from books.models import Chapter, Book
from django.test import TestCase
from django.contrib.auth.models import User
from rest_framework.exceptions import ValidationError
from .models import TextSelection, WriterFeedback, Highlight
from .serializers import (
    TextSelectionSerializer,
    WriterFeedbackSerializer,
    HighlightSerializer,
)


class CommentManagerTestCase(TestCase):
    def setUp(self):
        # Create some test data
        self.user = User.objects.create(username="testuser")
        self.book = Book.objects.create(title="Test Book", user=self.user)
        self.chapter = Chapter.objects.create(book=self.book)

        self.chapter2 = Chapter.objects.create(book=self.book)

        self.selection1 = TextSelection.objects.create(
            chapter=self.chapter, offset=10, offset_end=20, text="Test text"
        )

        self.selection2 = TextSelection.objects.create(
            chapter=self.chapter,
            offset=10,
            offset_end=20,
            text="Test text",
            floating=True,
        )

        self.selection3 = TextSelection.objects.create(
            chapter=self.chapter, offset=10, offset_end=20, text="Test text"
        )

        self.selection4 = TextSelection.objects.create(
            chapter=self.chapter2, offset=10, offset_end=20, text="Test text"
        )

        self.comment1 = WriterFeedback.objects.create(
            user=self.user, selection=self.selection1, comment="Test comment 1"
        )

        self.comment_dismissed = WriterFeedback.objects.create(
            user=self.user,
            selection=self.selection2,
            comment="Test comment 2",
            dismissed=True,
        )

        self.comment_suggestion = WriterFeedback.objects.create(
            user=self.user,
            selection=self.selection3,
            comment="Test comment 3",
            suggestion=True,
        )

        self.chapter2_comment = WriterFeedback.objects.create(
            user=self.user, selection=self.selection4, comment="Test comment 4"
        )

    def test_all_exclude_ghost(self):
        comments = WriterFeedback.objects.all_exclude_ghost()
        self.assertEqual(comments.count(), 3)  # Both comments should be included

    def test_all_exclude_dismissed(self):
        comments = WriterFeedback.objects.all_exclude_dismissed()
        self.assertEqual(
            comments.count(), 3
        )  # Only the first comment should be included

    def test_all_active(self):
        comments = WriterFeedback.objects.all_active()
        self.assertEqual(
            comments.count(), 3
        )  # Only the first comment should be included

    def test_all_suggestions(self):
        comments = WriterFeedback.objects.all_suggestions()
        self.assertEqual(comments.count(), 1)

    def test_all_comments(self):
        comments_active = WriterFeedback.objects.all_comments(
            chapter_pk=self.chapter.id
        )
        comments_nonactive = WriterFeedback.objects.all_comments(
            include_dismissed=True, include_ghost=True
        )
        self.assertEqual(
            comments_active.count(), 1
        )  # Only non-suggestion comment should be
        self.assertEqual(
            comments_nonactive.count(), 3
        )  # Both comments should be included

        chapter2_comments = WriterFeedback.objects.all_comments(
            chapter_pk=self.chapter2.id
        )
        self.assertEqual(chapter2_comments.count(), 1)


class CommentModelTestCase(TestCase):
    def setUp(self):
        # Create test data
        self.user = User.objects.create(username="testuser")
        self.book = Book.objects.create(title="Test Book", user=self.user)
        self.chapter = Chapter.objects.create(book=self.book)

        self.selection = TextSelection.objects.create(
            chapter=self.chapter, offset=10, offset_end=20, text="Test text"
        )
        self.selection2 = TextSelection.objects.create(
            chapter=self.chapter, offset=10, offset_end=20, text="Test text"
        )

    def test_get_receiver_method(self):
        comment = WriterFeedback.objects.create(
            user=self.user, selection=self.selection, comment="Test comment"
        )
        receiver = comment.get_receiver()
        self.assertEqual(receiver, self.book.user)


# class TextSelectionSerializerTestCase(TestCase):
#     def test_text_selection_serialization(self):
#         self.chapter = Chapter.objects.create(book=Book.objects.create(title="Test Book"))
#         # print(Chapter.objects.all().first().id)
#         selection_data = {
#             'chapter': self.chapter.id,
#             'offset': 10,
#             'offset_end': 20,
#             'text': 'Test text',
#             'floating': False,
#         }
#         serializer = TextSelectionSerializer(data=selection_data)
#         self.assertTrue(serializer.is_valid())
#         serialized_data = serializer.data
#         # print(serialized_data)
#         # print(selection_data)
#         self.assertEqual(serialized_data, selection_data)


class WriterFeedbackSerializerTestCase(TestCase):
    def setUp(self):
        self.user = User.objects.create(username="testuser")
        self.chapter = Chapter.objects.create(
            book=Book.objects.create(title="Test Book", user=self.user)
        )
        self.selection_data = {
            "chapter": self.chapter.id,
            "offset": 10,
            "offset_end": 20,
            "text": "Test text",
            "floating": False,
        }
        self.comment_data = {
            "user": self.user.id,
            "selection": self.selection_data,
            "comment": "Test comment",
            "dismissed": False,
            "suggestion": False,
        }

    def test_comment_serialization(self):
        serializer = WriterFeedbackSerializer(data=self.comment_data)
        # self.assertTrue(serializer.is_valid())
        serializer.is_valid(raise_exception=True)
        serializer.save()

        feedback = WriterFeedback.objects.all()
        self.assertEqual(feedback.count(), 1)

        selection = TextSelection.objects.all()
        self.assertEqual(selection.count(), 1)

    def test_comment_deserialization(self):
        serializer = WriterFeedbackSerializer(data=self.comment_data)
        # self.assertTrue(serializer.is_valid())
        serializer.is_valid()
        # print(serializer.error_messages)
        comment_instance = serializer.save()
        self.assertEqual(comment_instance.user, self.user)
        self.assertEqual(comment_instance.comment, "Test comment")

    def test_comment_validation(self):
        # Test with missing 'user' field
        invalid_data = self.comment_data.copy()
        invalid_data.pop("selection")
        serializer = WriterFeedbackSerializer(data=invalid_data)
        self.assertFalse(serializer.is_valid())
        with self.assertRaises(ValidationError):
            serializer.is_valid(raise_exception=True)
