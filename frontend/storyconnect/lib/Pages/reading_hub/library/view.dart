import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/state/reading_hub_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/book_grid_widget.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/tabbed_widget.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';
import 'package:storyconnect/Widgets/header.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  LibraryState createState() => LibraryState();
}

class LibraryState extends State<LibraryView> {
  bool initialLoad = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialLoad) {
        initialLoad = false;
        final libraryHomeBloc = context.read<ReadingHubBloc>();
        libraryHomeBloc.add(const FetchLibraryBooksEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(context: context),
        body: Center(
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.65,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    const Header(
                      title: "Library",
                    ),
                    Expanded(child:
                        BlocBuilder<ReadingHubBloc, ReadingHubStruct>(builder:
                            (BuildContext context, ReadingHubStruct libState) {
                      Widget toReturn;

                      if (libState.loadingStruct.isLoading) {
                        toReturn = LoadingWidget(
                            loadingStruct: libState.loadingStruct);
                      } else {
                        List<Book> reading = [];
                        List<Book> completed = [];
                        List<Book> unread = [];

                        for (MapEntry<Library, Book> entry
                            in libState.libraryBookMap.entries) {
                          if (entry.key.status == 1) {
                            reading.add(entry.value);
                          } else if (entry.key.status == 2) {
                            completed.add(entry.value);
                          } else {
                            unread.add(entry.value);
                          }
                        }

                        toReturn = TabbedBookDisplayWidget(
                          tabs: const [
                            Tab(text: "Currently Reading"),
                            Tab(text: "Completed"),
                            Tab(text: "Unread")
                          ],
                          children: [
                            BookGridWidget(
                              books: reading,
                              category: 1,
                            ),
                            BookGridWidget(
                              books: completed,
                              category: 2,
                            ),
                            BookGridWidget(
                              books: unread,
                              category: 3,
                            ),
                          ],
                        );
                      }
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: toReturn,
                      );
                    }))
                  ],
                ))));
  }
}
