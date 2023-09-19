from django.test import TestCase
from django.contrib.auth.models import User
from .managers import CommentManager
from books.models import Chapter, Book
from django.test import TestCase
from django.contrib.auth.models import User
from rest_framework.exceptions import ValidationError
from .models import TextSelection, Comment, Annotation, Highlight
from .serializers import (
    TextSelectionSerializer,
    CommentSerializer,
    AnnotationSerializer,
    HighlightSerializer,
)

class CommentManagerTestCase(TestCase):
    def setUp(self):
        # Create some test data
        self.user = User.objects.create(username='testuser')
        self.book = Book.objects.create(title="Test Book", owner=self.user)
        self.chapter = Chapter.objects.create(book=self.book)
        
        self.selection1 = TextSelection.objects.create(
            chapter=self.chapter, offset=10, length=20, text='Test text'
        )

        self.selection2 = TextSelection.objects.create(
            chapter=self.chapter, offset=10, length=20, text='Test text', floating=True
        )

        self.selection3 = TextSelection.objects.create(
            chapter=self.chapter, offset=10, length=20, text='Test text'
        )

        self.comment1 = Comment.objects.create(
            user=self.user, selection=self.selection1, content='Test comment 1'
        )

        self.comment_dismissed = Comment.objects.create(
            user=self.user, selection=self.selection2, content='Test comment 2', dismissed=True
        )

        self.comment_suggestion = Comment.objects.create(
            user=self.user, selection=self.selection3, content='Test comment 3', suggestion='Test suggestion'
        )
    
    def test_all_exclude_ghost(self):
        comments = Comment.objects.all_exclude_ghost()
        self.assertEqual(comments.count(), 2)  # Both comments should be included
    
    def test_all_exclude_dismissed(self):
        comments = Comment.objects.all_exclude_dismissed()
        self.assertEqual(comments.count(), 2)  # Only the first comment should be included
    
    def test_all_active(self):
        comments = Comment.objects.all_active()
        self.assertEqual(comments.count(), 2)  # Only the first comment should be included
    
    def test_all_suggestions(self):
        comments = Comment.objects.all_suggestions()
        self.assertEqual(comments.count(), 1)  # There are no suggestions
    
    def test_all_comments(self):
        comments_active = Comment.objects.all_comments()
        comments_nonactive = Comment.objects.all_comments(active=False)
        self.assertEqual(comments_active.count(), 1)  # Only non-suggestion comment should be 
        self.assertEqual(comments_nonactive.count(), 2)  # Both comments should be included

class CommentModelTestCase(TestCase):
    def setUp(self):
        # Create test data
        self.user = User.objects.create(username='testuser')
        self.book = Book.objects.create(title="Test Book", owner=self.user)
        self.chapter = Chapter.objects.create(book=self.book)

        self.selection = TextSelection.objects.create(
            chapter=self.chapter, offset=10, length=20, text='Test text'
        )
        self.selection2 = TextSelection.objects.create(
            chapter=self.chapter, offset=10, length=20, text='Test text'
        )
    
    def test_is_suggestion_property(self):
        comment = Comment.objects.create(
            user=self.user, selection=self.selection, suggestion='Test suggestion'
        )
        comment2 = Comment.objects.create(
            user=self.user, selection=self.selection2, content='Test comment'
        )
        self.assertTrue(comment.is_suggestion)
        self.assertFalse(comment2.is_suggestion)
    
    def test_is_ghost_property(self):
        comment = Comment.objects.create(
            user=self.user, selection=self.selection, content='Test comment'
        )
        self.assertFalse(comment.is_ghost)

        self.selection.floating = True
        self.selection.save()
        self.assertTrue(comment.is_ghost)
    
    def test_get_receiver_method(self):
        comment = Comment.objects.create(
            user=self.user, selection=self.selection, content='Test comment'
        )
        receiver = comment.get_receiver()
        self.assertEqual(receiver, self.book.owner)

# class GptCommentManagerTestCase(TestCase):
#     def setUp(self):
#         # Create some test data
#         self.user = User.objects.create(username='testuser')
#         self.book = Book.objects.create(title="Test Book", owner=self.user)
#         self.chapter = Chapter.objects.create(book=self.book)

#         self.selection1 = TextSelection.objects.create(
#             chapter=self.chapter, offset=10, length=20, text='Test text'
#         )

#         self.selection2 = TextSelection.objects.create(
#             chapter=self.chapter, offset=10, length=20, text='Test text', floating=True
#         )

#         self.comment1 = Comment.objects.create(
#             user=self.user, selection=self.selection1, content='Test comment 1'
#         )

#         self.comment_dismissed = Comment.objects.create(
#             user=self.user, selection=self.selection2, content='Test comment 2', dismissed=True
#         )

#         self.comment_suggestion = Comment.objects.create(
#             user=self.user, selection=self.selection1, content='Test comment 3', suggestion='Test suggestion'
#         )

#     def test_all_exclude_ghost(self):
#         comments = Comment.objects.all_exclude_ghost()
#         self.assertEqual(comments.count(), 2)  # Both comments should be included
    
#     def test_all_exclude_dismissed(self):
#         comments = Comment.objects.all_exclude_dismissed()
#         self.assertEqual(comments.count(), 2)  # Only the first comment should be included
    
#     def test_all_active(self):
#         comments = Comment.objects.all_active()
#         self.assertEqual(comments.count(), 2)  # Only the first comment should be included
    
#     def test_all_suggestions(self):
#         comments = Comment.objects.all_suggestions()
#         self.assertEqual(comments.count(), 1)  # There are no suggestions
    
#     def test_all_comments(self):
#         comments_active = Comment.objects.all_comments()
#         comments_nonactive = Comment.objects.all_comments(active=False)
#         self.assertEqual(comments_active.count(), 1)  # Only non-suggestion comment should be 
#         self.assertEqual(comments_nonactive.count(), 2)  # Both comments should be included
#     # Your test cases go here

# class GptCommentModelTestCase(TestCase):
#     def setUp(self):
#         # Create test data
#         self.user = User.objects.create(username='testuser')
#         self.book = Book.objects.create(title="Test Book", owner=self.user)
#         self.chapter = Chapter.objects.create(book=self.book)

#         self.selection = TextSelection.objects.create(
#             chapter=self.chapter, offset=10, length=20, text='Test text'
#         )

    
#     def test_is_suggestion_property(self):
#         comment = Comment.objects.create(
#             user=self.user, selection=self.selection, suggestion='Test suggestion'
#         )
#         comment2 = Comment.objects.create(
#             user=self.user, selection=self.selection, content='Test comment'
#         )
#         self.assertTrue(comment.is_suggestion)
#         self.assertFalse(comment2.is_suggestion)
    
#     def test_is_ghost_property(self):
#         comment = Comment.objects.create(
#             user=self.user, selection=self.selection, content='Test comment'
#         )
#         self.assertFalse(comment.is_ghost)

#         self.selection.floating = True
#         self.selection.save()
#         self.assertTrue(comment.is_ghost)
    
#     def test_get_receiver_method(self):
#         comment = Comment.objects.create(
#             user=self.user, selection=self.selection, content='Test comment'
#         )
#         receiver = comment.get_receiver()
#         self.assertEqual(receiver, self.book.owner)

class TextSelectionSerializerTestCase(TestCase):
    def test_text_selection_serialization(self):
        Chapter.objects.create(book=Book.objects.create(title="Test Book"))
        print(Chapter.objects.all().first().id)
        selection_data = {
            'chapter': Chapter.objects.all().first().id,
            'offset': 10,
            'length': 20,
            'text': 'Test text',
            'floating': False,
        }
        serializer = TextSelectionSerializer(data=selection_data)
        self.assertTrue(serializer.is_valid())
        serialized_data = serializer.data
        print(serialized_data)
        print(selection_data)
        self.assertEqual(serialized_data, selection_data)

class CommentSerializerTestCase(TestCase):
    def setUp(self):
        self.user = User.objects.create(username='testuser')
        Chapter.objects.create(book=Book.objects.create(title="Test Book", owner=self.user))
        self.selection_data = {
            'chapter': Chapter.objects.all().first().id,
            'offset': 10,
            'length': 20,
            'text': 'Test text',
            'floating': False,
        }
        self.comment_data = {
            'user': self.user,
            'selection': self.selection_data,
            'content': 'Test comment',
            'dismissed': False,
            'suggestion': None,
        }

    def test_comment_serialization(self):
        serializer = CommentSerializer(data=self.comment_data)
        # self.assertTrue(serializer.is_valid())
        serializer.is_valid(raise_exception=True)
        print(serializer.error_messages)
        serialized_data = serializer.data
        self.assertEqual(serialized_data, self.comment_data)

    def test_comment_deserialization(self):
        serializer = CommentSerializer(data=self.comment_data)
        # self.assertTrue(serializer.is_valid())
        serializer.is_valid()
        print(serializer.error_messages)
        comment_instance = serializer.save()
        self.assertEqual(comment_instance.user, self.user)
        self.assertEqual(comment_instance.content, 'Test comment')

    def test_comment_validation(self):
        # Test with missing 'user' field
        invalid_data = self.comment_data.copy()
        invalid_data.pop('selection')
        serializer = CommentSerializer(data=invalid_data)
        self.assertFalse(serializer.is_valid())
        with self.assertRaises(ValidationError):
            serializer.is_valid(raise_exception=True)
