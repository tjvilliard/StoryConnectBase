import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/page_view/page_sliver.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ReadingPageView extends StatefulWidget {
  const ReadingPageView({super.key});

  @override
  ReadingPageViewState createState() => ReadingPageViewState();
}

class ReadingPageViewState extends State<ReadingPageView> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: RenderPageSliver.pageWidth),
        child: BlocConsumer<ChapterBloc, ChapterBlocStruct>(
            listener: (context, state) {
          textController.text = state.chapters[state.chapterIndex] ?? "";
        }, buildWhen: (previous, current) {
          return previous.chapterIndex != current.chapterIndex ||
              previous.loadingStruct != current.loadingStruct;
        }, builder: (context, state) {
          Widget toReturn;
          if (state.loadingStruct.isLoading) {
            toReturn = LoadingWidget(
              loadingStruct: state.loadingStruct,
            );
          } else {
            toReturn = SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]!, width: 1),
                      color: Colors.white,
                    ),
                    constraints:
                        BoxConstraints(minHeight: RenderPageSliver.pageHeight),
                    child: TextField(
                      decoration: null,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black, fontSize: 16),
                      controller: textController,
                      readOnly: true,
                      maxLines: null,
                    )));
          }
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500), child: toReturn);
        }));
  }
}
