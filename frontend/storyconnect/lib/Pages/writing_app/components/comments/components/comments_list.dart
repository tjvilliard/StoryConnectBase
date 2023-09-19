import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_app/components/comments/components/comment_widget.dart';
import 'package:storyconnect/Pages/writing_app/components/comments/state/feedback_bloc.dart';

class CommentsListWidget extends StatelessWidget {
  final List<Comment> comments = _mockGetComments();

  CommentsListWidget({
    super.key,
  });

  static List<Comment> getComments(BuildContext context, FeedbackState state) {
    return _mockGetComments();

    // final currentChapterIndex = context.read<ChapterBloc>().state.currentIndex;

    //   final List<Comment> comments = state.comments[currentChapterIndex] ?? [];

    //   // then get the rest of the comments; we just want to show the current chapter's before the rest
    //   for (final chapterId in state.comments.keys) {
    //     if (chapterId != currentChapterIndex) {
    //       comments.addAll(state.comments[chapterId] ?? []);
    //     }
    //   }
    //   return comments;
  }

  // for testing purposes, generate a list of comments
  static List<Comment> _mockGetComments() {
    return [
      Comment(id: 1, userId: 1, chapterId: 1, comment: "This is a comment"),
      Comment(id: 2, userId: 1, chapterId: 1, comment: "This is a comment"),
      Comment(id: 3, userId: 1, chapterId: 1, comment: "This is a comment"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(builder: (context, state) {
      return ListView.separated(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return CommentWidget(comment: comments[index]);
        },
        separatorBuilder: (context, index) {
          if (index != comments.length - 1) {
            return Divider();
          } else {
            return Container();
          }
        },
      );
    });
  }
}
