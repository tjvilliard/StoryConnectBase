import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Pages/writing_app/components/menu_bar/rich_text_menu.dart';
import 'package:storyconnect/Pages/writing_app/components/settings/writer_settings_button.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/chapter/chapter_navigation.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/view.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/view.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/view.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/view.dart';
import 'package:storyconnect/Pages/writing_app/components/menu_bar/writing_menubar.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';
import 'package:visual_editor/visual-editor.dart';

class WritingAppView extends StatefulWidget {
  final int? bookId;
  const WritingAppView({super.key, required this.bookId});

  @override
  WritingAppViewState createState() => WritingAppViewState();
}

class WritingAppViewState extends State<WritingAppView> {
  bool firstLoaded = true;
  String? title;
  @override
  void initState() {
    super.initState();
    if (firstLoaded) {
      firstLoaded = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        WritingBloc writingBloc = context.read<WritingBloc>();
        writingBloc.add(SetEditorControllerCallbackEvent(callback: getEditorController));

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
  }

  EditorController? getEditorController() {
    if (mounted) {
      return context.read<WritingUIBloc>().state.editorController;
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
                icon: const Icon(FontAwesomeIcons.house),
                onPressed: () {
                  final beamed = Beamer.of(context).beamBack();
                  if (!beamed) {
                    Beamer.of(context).beamToNamed(PageUrls.writerHome);
                  }
                },
              ),
              const SizedBox(
                width: 10,
              ),
              BlocBuilder<WritingUIBloc, WritingUIState>(builder: (context, state) {
                Widget toReturn;
                if (state.loadingStruct.isLoading) {
                  toReturn = LoadingWidget(loadingStruct: state.loadingStruct);
                } else if (state.isSaving) {
                  toReturn = LoadingWidget(loadingStruct: LoadingStruct.message("Saving"), short: true);
                } else if (state.book == null) {
                  toReturn = Text("No book was found", style: Theme.of(context).textTheme.displaySmall);
                } else {
                  toReturn = toReturn = Text(state.book!.title, style: Theme.of(context).textTheme.displaySmall);
                }

                return Flexible(child: AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: toReturn));
              }),
            ],
          ),
          centerTitle: false,
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 30, left: 10),
                child: BookSettingsButton(uiBloc: context.read<WritingUIBloc>()))
          ],
        ),
        body: ChangeNotifierProvider<ScrollController>(
          create: (context) {
            return ScrollController();
          },
          child: const Column(
            children: [
              Row(
                children: [
                  WritingMenuBar(),
                  SizedBox(
                    width: 10,
                  ),
                  RichTextMenuBar()
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
                    children: [FeedbackWidget(), RoadUnblockerWidget(), ContinuityWidget()],
                  )
                ],
              ))
            ],
          ),
        ));
  }
}
