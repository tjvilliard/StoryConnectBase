import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_sliver.dart';

class PagingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: RenderPageSliver.pageWidth),
        child: BlocBuilder<ChapterBloc, ChapterBlocStruct>(
            builder: (context, state) {
          return SingleChildScrollView(
              child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            color: Colors.white,
            constraints: BoxConstraints(minHeight: RenderPageSliver.pageHeight),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your text here',
              ),
              controller: TextEditingController(
                  text: state.chapters[state.currentIndex]),
              onChanged: (value) {
                BlocProvider.of<ChapterBloc>(context)
                    .add(UpdateChapterEvent(text: value));
              },
              maxLines: null, // Allows multiple lines
              keyboardType: TextInputType.multiline,
            ),
          ));
        }));
  }
}
