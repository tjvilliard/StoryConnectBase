import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/components/background_panels/panel_divider.dart';
import 'package:storyconnect/Pages/reading_hub/components/background_panels/solid_panel.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/panel_item.dart';
import 'package:storyconnect/Pages/reading_hub/components/background_panels/content_panel.dart';
import 'package:storyconnect/Pages/reading_hub/home/state/reading_home_bloc.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';
import 'package:storyconnect/theme.dart';

/// The Reading Home View: Displays a curated set of book content for the readers.
class ReadingHomeView extends StatefulWidget {
  const ReadingHomeView({Key? key}) : super(key: key);

  @override
  ReadingHomeState createState() => ReadingHomeState();
}

class ReadingHomeState extends State<ReadingHomeView> {
  bool initialLoad = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialLoad) {
        initialLoad = false;
        final readingHomeBloc = context.read<ReadingHomeBloc>();
        readingHomeBloc.add(GetBooksEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(context: context),
        body: Center(child: Container(child:
            BlocBuilder<ReadingHomeBloc, ReadingHomeStruct>(
                builder: (BuildContext context, ReadingHomeStruct homeState) {
          List<ContentPanel> toReturn;
          if (homeState.loadingStruct.isLoading) {
            toReturn = <ContentPanel>[
              SolidContentPanel(
                  children: [LoadingItem()],
                  primary: Theme.of(context).canvasColor)
            ];
          } else {
            toReturn = <ContentPanel>[
              SolidContentPanel(
                  children: [BlankPanel(height: 1.5)],
                  primary: Colors.transparent),
              ContentDivider(
                color: myColorScheme.secondary,
                thickness: 2.0,
              ),
              FadedContentPanel.titledBookPanel(
                  homeState.libraryBooks,
                  myColorScheme.secondary.withOpacity(0.45),
                  Theme.of(context).canvasColor,
                  "Continue Reading",
                  "Pick up where you left off",
                  false),
              ContentDivider(
                color: myColorScheme.secondary,
                thickness: 2.0,
              ),
              FadedContentPanel.titledBookPanel(
                  homeState.books,
                  Colors.grey.withOpacity(.1),
                  Theme.of(context).canvasColor,
                  "Browse some Books",
                  "",
                  true)
            ];
          }
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: false,
                child: Column(children: toReturn),
              ));
        }))));
  }
}
