import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

class FeedbackWidgetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (BuildContext context, FeedbackState feedbackState) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [],
        ),
      );
    });
  }
}
