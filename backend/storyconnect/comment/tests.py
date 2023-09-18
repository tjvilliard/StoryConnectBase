from django.test import TestCase
from django.contrib.auth.models import User
from .managers import CommentManager
from books.models import Chapter
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
        self.chapter = Chapter.objects.create(title='Test Chapter')
        self.selection = TextSelection.objects.create(
            chapter=self.chapter, offset=10, length=20, text='Test text'
        )
        self.comment1 = Comment.objects.create(
            user=self.user, selection=self.selection, content='Test comment 1'
        )
        self.comment2 = Comment.objects.create(
            user=self.user, selection=self.selection, content='Test comment 2', dismissed=True
        )
    
    def test_all_exclude_ghost(self):
        comments = Comment.objects.all_exclude_ghost()
        self.assertEqual(comments.count(), 2)  # Both comments should be included
    
    def test_all_exclude_dismissed(self):
        comments = Comment.objects.all_exclude_dismissed()
        self.assertEqual(comments.count(), 1)  # Only the first comment should be included
    
    def test_all_active(self):
        comments = Comment.objects.all_active()
        self.assertEqual(comments.count(), 1)  # Only the first comment should be included
    
    def test_all_suggestions(self):
        comments = Comment.objects.all_suggestions()
        self.assertEqual(comments.count(), 0)  # There are no suggestions
    
    def test_all_comments(self):
        comments = Comment.objects.all_comments()
        self.assertEqual(comments.count(), 1)  # Only non-suggestion comment should be included

class CommentModelTestCase(TestCase):
    def setUp(self):
        # Create test data
        self.user = User.objects.create(username='testuser')
        self.chapter = Chapter.objects.create(title='Test Chapter')
        self.selection = TextSelection.objects.create(
            chapter=self.chapter, offset=10, length=20, text='Test text'
        )
    
    def test_is_suggestion_property(self):
        comment = Comment.objects.create(
            user=self.user, selection=self.selection, suggestion='Test suggestion'
        )
        self.assertTrue(comment.is_suggestion)
    
    def test_is_ghost_property(self):
        comment = Comment.objects.create(
            user=self.user, selection=self.selection, content='Test comment'
        )
        self.assertFalse(comment.is_ghost)
    
    def test_get_receiver_method(self):
        comment = Comment.objects.create(
            user=self.user, selection=self.selection, content='Test comment'
        )
        receiver = comment.get_receiver()
        self.assertEqual(receiver, self.user)



class TextSelectionSerializerTestCase(TestCase):
    def test_text_selection_serialization(self):
        selection_data = {
            'chapter': None,
            'offset': 10,
            'length': 20,
            'text': 'Test text',
            'floating': False,
        }
        serializer = TextSelectionSerializer(data=selection_data)
        self.assertTrue(serializer.is_valid())
        serialized_data = serializer.data
        self.assertEqual(serialized_data, selection_data)

class CommentSerializerTestCase(TestCase):
    def setUp(self):
        self.user = User.objects.create(username='testuser')
        self.selection_data = {
            'chapter': None,
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
        self.assertTrue(serializer.is_valid())
        serialized_data = serializer.data
        self.assertEqual(serialized_data, self.comment_data)

    def test_comment_deserialization(self):
        serializer = CommentSerializer(data=self.comment_data)
        self.assertTrue(serializer.is_valid())
        comment_instance = serializer.save()
        self.assertEqual(comment_instance.user, self.user)
        self.assertEqual(comment_instance.content, 'Test comment')

    def test_comment_validation(self):
        # Test with missing 'user' field
        invalid_data = self.comment_data.copy()
        invalid_data.pop('user')
        serializer = CommentSerializer(data=invalid_data)
        self.assertFalse(serializer.is_valid())
        with self.assertRaises(ValidationError):
            serializer.is_valid(raise_exception=True)

# Similar test cases can be created for AnnotationSerializer and HighlightSerializer
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

class TextSelectionSerializerTestCase(TestCase):
    def test_text_selection_serialization(self):
        selection_data = {
            'chapter': None,
            'offset': 10,
            'length': 20,
            'text': 'Test text',
            'floating': False,
        }
        serializer = TextSelectionSerializer(data=selection_data)
        self.assertTrue(serializer.is_valid())
        serialized_data = serializer.data
        self.assertEqual(serialized_data, selection_data)

class CommentSerializerTestCase(TestCase):
    def setUp(self):
        self.user = User.objects.create(username='testuser')
        self.selection_data = {
            'chapter': None,
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
        self.assertTrue(serializer.is_valid())
        serialized_data = serializer.data
        self.assertEqual(serialized_data, self.comment_data)

    def test_comment_deserialization(self):
        serializer = CommentSerializer(data=self.comment_data)
        self.assertTrue(serializer.is_valid())
        comment_instance = serializer.save()
        self.assertEqual(comment_instance.user, self.user)
        self.assertEqual(comment_instance.content, 'Test comment')

    def test_comment_validation(self):
        # Test with missing 'user' field
        invalid_data = self.comment_data.copy()
        invalid_data.pop('user')
        serializer = CommentSerializer(data=invalid_data)
        self.assertFalse(serializer.is_valid())
        with self.assertRaises(ValidationError):
            serializer.is_valid(raise_exception=True)


