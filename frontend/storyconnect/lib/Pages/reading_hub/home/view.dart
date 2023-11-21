import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/big_book_list.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/solid_panel.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/panel_item.dart';
import 'package:storyconnect/Pages/reading_hub/home/state/reading_home_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';

/// The Reading Home View: Displays a curated set of book content for the readers.
class ReadingHomeView extends StatefulWidget {
  const ReadingHomeView({super.key});

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
        final libraryBloc = context.read<LibraryBloc>();
        libraryBloc.add(GetLibraryEvent());
        readingHomeBloc.add(GetBooksEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(context: context),
        body: Center(child: BlocBuilder<ReadingHomeBloc, ReadingHomeStruct>(
            builder: (BuildContext context, ReadingHomeStruct homeState) {
          return BlocBuilder<LibraryBloc, LibraryStruct>(
            builder: (BuildContext context, LibraryStruct libraryState) {
              List<Widget> toReturn;
              if (homeState.loadingStruct.isLoading || libraryState.loadingStruct.isLoading) {
                toReturn = <Widget>[
                  SolidPanel(primary: Theme.of(context).canvasColor, children: const [LoadingItem()]),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Divider(
                      height: 10,
                      thickness: .5,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  SolidPanel(primary: Theme.of(context).canvasColor, children: const [LoadingItem()])
                ];
              } else {
                /// Build scrolling paginated view of book panels
                toReturn = <Widget>[
                  SolidPanel(
                    primary: Theme.of(context).canvasColor,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                          alignment: Alignment.centerLeft,
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Text(
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleLarge,
                              "Continue Reading...")),
                      BigBookListWidget(books: libraryState.libraryBooks)
                    ],
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Divider(
                      height: 10,
                      thickness: .5,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  SolidPanel(
                    primary: Theme.of(context).canvasColor,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Text(
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleLarge,
                              "Latest in 'Category'")),
                      BigBookListWidget(books: homeState.books)
                    ],
                  )
                ];
              }
              return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    child: Column(children: toReturn),
                  ));
            },
          );
        })));
  }
}
