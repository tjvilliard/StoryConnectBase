import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/view.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/reading_menubar.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/view.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/view.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';
import 'package:visual_editor/controller/controllers/editor-controller.dart';
import 'package:visual_editor/visual-editor.dart';

class ReadingAppView extends StatefulWidget {
  final int? bookId;
  const ReadingAppView({super.key, required this.bookId});

  @override
  _ReadingAppViewState createState() => _ReadingAppViewState();
}

class _ReadingAppViewState extends State<ReadingAppView> {
  bool firstLoaded = true;
  String? title;
  @override
  void initState() {
    if (firstLoaded) {
      firstLoaded = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ReadingBloc readingBloc = context.read<ReadingBloc>();
        readingBloc.add(
            SetEditorControllerCallbackEvent(callback: getEditorController));

        if (widget.bookId == null) {
          Beamer.of(context).beamToNamed(PageUrls.readerHome);
          return;
        }
        BlocProvider.of<ReadingUIBloc>(context).add(ReadingLoadEvent(
          bookId: widget.bookId!,
          readingBloc: context.read<ReadingBloc>(),
          feedbackBloc: context.read<FeedbackBloc>(),
        ));
      });
    }
    super.initState();
  }

  EditorController? getEditorController() {
    if (mounted) {
      return context.read<ReadingUIBloc>().state.editorController;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: Icon(FontAwesomeIcons.house),
                onPressed: () {
                  final beamed = Beamer.of(context).beamBack();
                  if (!beamed) {
                    Beamer.of(context).beamToNamed(PageUrls.readerHome);
                  }
                },
              ),
              SizedBox(
                width: 10,
              ),
              BlocBuilder<ReadingUIBloc, ReadingUIState>(
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
              })
            ],
          ),
          centerTitle: false,
        ),
        body: ChangeNotifierProvider<ScrollController>(
            create: (context) {
              return ScrollController();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    fit: FlexFit.loose,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                            child: Align(
                          alignment: Alignment.center,
                          child: ReadingPageView(),
                        )),
                        Positioned.fill(
                            child: Align(
                          alignment: Alignment.topLeft,
                          child: ChapterNavigation(),
                        )),
                        Positioned.fill(
                            child: Align(
                          alignment: Alignment.topRight,
                          child: FeedbackWidget(),
                        ))
                      ],
                    )),
                Row(children: [ReadingMenuBar(bookId: widget.bookId!)]),
              ],
            )));
  }
}
