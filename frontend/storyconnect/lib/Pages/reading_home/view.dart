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

/// Encapulates all of the functionality required by the reading home view.
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
        body: Center(
          child: Container(
              //constraints: BoxConstraints(maxWidth: 800.0),
              child: Column(children: [
            Header(title: "Reading Home"),
            Flexible(child: BlocBuilder<ReadingHomeBloc, ReadingHomeStruct>(
                builder: (context, state) {
              List<FadedContentPanel> toReturn;
              if (state.loadingStruct.isLoading) {
                Map<String, List<Book>> sample = sampleBooksData.build();

                toReturn = <FadedContentPanel>[
                  FadedContentPanel(
                      primary: Colors.green.withOpacity(
                          0.3), //TODO: fit color to set of app color scheme.
                      fade: Colors.transparent,
                      children: [
                        PanelDivider(
                          color: Colors.blue.withOpacity(0.6),
                          thickness: 5.0,
                        ),
                        LoadingItem(),
                        PanelDivider(
                          color: Colors.blue.withOpacity(0.6),
                          thickness: 5.0,
                        ),
                      ]),
                  FadedContentPanel.taggedBookPanel(
                    sampleBooksData.build(),
                    Colors.green.withOpacity(0.3),
                    Colors.transparent,
                    "Title String Sample",
                  )
                ];
              } else {
                toReturn = <FadedContentPanel>[
                  FadedContentPanel(
                      primary: Colors.green,
                      fade: Colors.blue,
                      children: [LoadingItem()])
                ];
              }
              return AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    child: Column(children: toReturn),
                  ));
            }))
          ])),
        ));
  }
}
