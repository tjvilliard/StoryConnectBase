import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  ReadingAppViewState createState() => ReadingAppViewState();
}

class ReadingAppViewState extends State<ReadingAppView> {
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
            surfaceTintColor: Colors.transparent,
            centerTitle: false,
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.house),
                  onPressed: () {
                    BeamerDelegate beamer = Beamer.of(context);
                    if (beamer.canBeamBack) {
                      beamer.beamBack();
                    } else {
                      beamer.beamToNamed(PageUrls.readerHome);
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: BlocBuilder<ReadingUIBloc, ReadingUIState>(
                          builder: (context, state) {
                            Widget toReturn;
                            if (state.title != null) {
                              toReturn = Text(state.title!,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style:
                                      Theme.of(context).textTheme.displaySmall);
                            } else {
                              toReturn = LoadingWidget(
                                  loadingStruct: state.loadingStruct);
                            }
                            return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: toReturn);
                          },
                        )))
              ],
            )),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Flexible(
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
            ReadingMenuBar(bookId: widget.bookId!),
          ],
        ));
  }
}
