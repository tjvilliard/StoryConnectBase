import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/big_book_list.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/solid_panel.dart';
import 'package:storyconnect/Pages/reading_hub/components/sample_books.dart';
import 'package:storyconnect/Pages/reading_hub/home/state/reading_home_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialLoad) {
        initialLoad = false;
        final readingHomeBloc = context.read<ReadingHomeBloc>();
        final libraryBloc = context.read<LibraryBloc>();
        libraryBloc.add(GetLibraryEvent());
        readingHomeBloc.add(GetBooksEvent());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(context: context),
        body: BlocBuilder<ReadingHomeBloc, ReadingHomeStruct>(builder:
            (BuildContext context, ReadingHomeStruct readingHomeState) {
          return BlocBuilder<LibraryBloc, LibraryStruct>(
              builder: (BuildContext context, LibraryStruct library) {
            return Center(
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height,
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                          addAutomaticKeepAlives: true,
                          (BuildContext context, int index) {
                            if (index == 0) {
                              if (library.loadingStruct.isLoading) {
                                return SolidPanel.loadingPanel(
                                  primary: Theme.of(context).canvasColor,
                                  child: library.loadingStruct,
                                );
                              } else {
                                return SolidPanel(
                                    primary: Theme.of(context).canvasColor,
                                    children: [
                                      SizedBox(height: 25),
                                      Text(
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          "Continue Reading"),
                                      BigBookListWidget(
                                          books: library.libraryBooks)
                                    ]);
                              }
                            } else {
                              if (((index) % 2) != 0) {
                                return Divider();
                              } else {
                                return SolidPanel(
                                    primary: Theme.of(context).canvasColor,
                                    children: [
                                      Text(
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          "More Books in category Steamy"),
                                      BigBookListWidget(
                                          books: sampleBooksData.sample())
                                    ]);
                              }
                            }
                          },
                          childCount: 15,
                        )),
                      ],
                    )));
          });
        }));
  }
}
