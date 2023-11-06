import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/chapter/chapter_navigation.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/view.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/view.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/view.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/page_view.dart';
import 'package:storyconnect/Pages/writing_app/components/writing_menubar.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
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
          writingBloc: context.read<WritingBloc>(),
          feedbackBloc: context.read<FeedbackBloc>(),
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
                  final beamed = Beamer.of(context).beamBack();
                  if (!beamed) {
                    Beamer.of(context).beamToNamed(PageUrls.writerHome);
                  }
                },
              ),
              SizedBox(
                width: 10,
              ),
              BlocBuilder<WritingUIBloc, WritingUIState>(
                  builder: (context, state) {
                Widget toReturn;
                if (state.title != null) {
                  toReturn = Text(state.title!,
                      style: Theme.of(context).textTheme.displaySmall);
                } else {
                  toReturn = LoadingWidget(loadingStruct: state.loadingStruct);
                }
                return AnimatedSwitcher(
                    duration: Duration(milliseconds: 500), child: toReturn);
              }),
            ],
          ),
          centerTitle: false,
        ),
        body: ChangeNotifierProvider<ScrollController>(
          create: (context) {
            return ScrollController();
          },
          child: Column(
            children: [
              Row(
                children: [
                  WritingMenuBar(),
                  SizedBox(
                    width: 10,
                  ),
                  Placeholder(
                    fallbackHeight: 35,
                    fallbackWidth: 500,
                  )
                ],
              ),
              Flexible(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // where chapter navigation is displayed
                  ChapterNavigation(),
                  // Where pages are displayed
                  Flexible(child: WritingPageView()),

                  Row(
                    children: [
                      FeedbackWidget(),
                      RoadUnblockerWidget(),
                      ContinuityWidget()
                    ],
                  )
                ],
              ))
            ],
          ),
        ));
  }
}
