import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_sliver.dart';

class PagingView extends StatefulWidget {
  const PagingView({super.key});

  @override
  _PagingViewState createState() => _PagingViewState();
}

class _PagingViewState extends State<PagingView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (mounted) {
      final blocState = BlocProvider.of<ChapterBloc>(context).state;
      _controller.text = blocState.chapters[blocState.currentIndex] ?? "";
      ;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: RenderPageSliver.pageWidth),
        child: BlocConsumer<ChapterBloc, ChapterBlocStruct>(
            listener: (context, state) {
          _controller.text = state.chapters[state.currentIndex] ?? "";
          // if (state.caretOffset != null &&
          //     state.caretOffset != _controller.selection.baseOffset) {
          //   _controller.selection = TextSelection.fromPosition(
          //       TextPosition(offset: state.caretOffset!));
          // }
        }, buildWhen: (previous, current) {
          return previous.currentIndex != current.currentIndex;
        }, builder: (context, state) {
          return SingleChildScrollView(
              child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            color: Colors.white,
            constraints: BoxConstraints(minHeight: RenderPageSliver.pageHeight),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your text here',
              ),
              onChanged: (value) {
                context.read<ChapterBloc>().add(UpdateChapterEvent(
                      text: value,
                      selection: _controller.selection,
                    ));
              },
              maxLines: null, // Allows multiple lines
              keyboardType: TextInputType.multiline,
            ),
          ));
        }));
  }
}
