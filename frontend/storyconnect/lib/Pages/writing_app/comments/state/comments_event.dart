part of 'comments_bloc.dart';

abstract class CommentsEvent {
  const CommentsEvent();
}

class LoadChapterComments extends CommentsEvent {
  final int chapterId;
  const LoadChapterComments(this.chapterId);
}
