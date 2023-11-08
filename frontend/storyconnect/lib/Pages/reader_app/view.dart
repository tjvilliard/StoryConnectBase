import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/view.dart';
import 'package:storyconnect/Pages/reader_app/components/page_view/page_view.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/reading_menubar.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/view.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

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
        if (widget.bookId == null) {
          Beamer.of(context).beamToNamed(PageUrls.readerHome);
          return;
        }
        BlocProvider.of<ReadingUIBloc>(context).add(ReadingLoadEvent(
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
            centerTitle: false,
            title: Row(
              children: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.house),
                  onPressed: () {
                    BeamerDelegate beamer = Beamer.of(context);
                    if (beamer.canBeamBack) {
                      beamer.beamBack();
                    } else {
                      beamer.beamToNamed(PageUrls.readerHome);
                    }
                  },
                ),
                SizedBox(
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
                                duration: Duration(milliseconds: 500),
                                child: toReturn);
                          },
                        )))
              ],
            )),
        body: Column(
          children: [
            Flexible(
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
