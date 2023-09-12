import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_navigation.dart';
import 'package:storyconnect/Pages/writing_app/comments/view.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_view.dart';
import 'package:storyconnect/Pages/writing_app/writing_menubar.dart';
import 'package:storyconnect/Pages/writing_app/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class WritingAppView extends StatefulWidget {
  final int? bookId;
  const WritingAppView({super.key, required this.bookId});

  @override
  _WritingAppViewState createState() => _WritingAppViewState();
}

class _WritingAppViewState extends State<WritingAppView> {
  bool firstLoaded = true;
  String? title;
  @override
  void initState() {
    if (firstLoaded) {
      firstLoaded = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (widget.bookId == null) {
          Beamer.of(context).beamToNamed(PageUrls.writerHome);

          return;
        }
        BlocProvider.of<WritingUIBloc>(context).add(WritingLoadEvent(
          bookId: widget.bookId!,
          chapterBloc: context.read<ChapterBloc>(),
        ));
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.home_filled),
              onPressed: () {
                BeamerDelegate beamer = Beamer.of(context);
                if (beamer.canBeamBack) {
                  Beamer.of(context).beamBack();
                } else {
                  Beamer.of(context).beamToNamed(PageUrls.writerHome);
                }
              },
            ),
            SizedBox(
              width: 10,
            ),
            BlocBuilder<WritingUIBloc, WritingUIState>(
                builder: (context, state) {
              if (state.title != null) {
                return Text(state.title!,
                    style: Theme.of(context).textTheme.displaySmall);
              }
              return LoadingWidget(loadingStruct: state.loadingStruct);
            }),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          WritingMenuBar(),
          Flexible(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // where chapter navigation is displayed
              ChapterNavigation(),
              // Where pages are displayed
              Flexible(child: WritingPageView()),

              FeedbackWidget()
            ],
          ))
        ],
      ),
    );
  }
}
