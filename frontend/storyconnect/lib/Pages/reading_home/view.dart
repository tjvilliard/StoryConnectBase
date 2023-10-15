import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_home/components/content_panel/panel_item.dart';
import 'package:storyconnect/Pages/reading_home/components/sample_books.dart';
import 'package:storyconnect/Pages/reading_home/components/content_panel/content_panel.dart';
import 'package:storyconnect/Pages/reading_home/reading_home_bloc.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';
import 'package:storyconnect/Widgets/header.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';
import 'package:storyconnect/theme.dart';

/// The Reading Home View: Displays a curated set of book content for the readers.
///
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
                builder: (context, state) {
          List<ContentPanel> toReturn;
          if (state.loadingStruct.isLoading) {
            Map<String, List<Book>> sample = sampleBooksData.tagged();

            toReturn = <ContentPanel>[
              SolidContentPanel(
                  children: [BlankPanel()], primary: Colors.transparent),
              ContentDivider(
                color: myColorScheme.secondary,
                thickness: 2.0,
              ),
              FadedContentPanel.titledBookPanel(
                  sampleBooksData.sample(),
                  myColorScheme.secondary.withOpacity(0.45),
                  Colors.grey.shade200,
                  "Continue Reading",
                  "Pick up where you left off",
                  false),
              ContentDivider(
                color: myColorScheme.secondary,
                thickness: 2.0,
              ),
              FadedContentPanel.taggedBookPanel(
                  sampleBooksData.tagged(),
                  Colors.white,
                  Colors.grey.shade200,
                  "Categories recomended for you",
                  true),
              FadedContentPanel.titledBookPanel(
                  sampleBooksData.sample(),
                  Colors.white,
                  Colors.grey.shade200,
                  "Book Category 2",
                  "",
                  true)
            ];
          } else {
            toReturn = [];
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
