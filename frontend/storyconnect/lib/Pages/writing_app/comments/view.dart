import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/comments/state/comments_bloc.dart';
import 'package:storyconnect/Pages/writing_app/ui_state/writing_ui_bloc.dart';

class CommentsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(
        builder: (context, state) {
      if (state.commentsUIshown) {
        return Card(
            child: Container(
                width: 300,
                padding: EdgeInsets.all(10),
                child: BlocBuilder<CommentsBloc, CommentsState>(
                  builder: (context, state) {
                    return Container();
                  },
                )));
      }
      return Container();
    });
  }
}
