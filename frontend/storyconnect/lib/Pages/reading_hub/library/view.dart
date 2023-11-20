import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/book_grid_widget.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/tabbed_widget.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({Key? key}) : super(key: key);

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
        final libraryHomeBloc = context.read<LibraryBloc>();
        libraryHomeBloc.add(GetLibraryEvent());
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
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    style: Theme.of(context).textTheme.displaySmall,
                    "Library",
                  ),
                ),
                Expanded(child: BlocBuilder<LibraryBloc, LibraryStruct>(
                    builder: (BuildContext context, LibraryStruct libState) {
                  if (libState.loadingStruct.isLoading) {
                    return LoadingWidget(loadingStruct: libState.loadingStruct);
                  } else {
                    return TabbedBookDisplayWidget(
                      tabs: [
                        Tab(text: "Currently Reading"),
                        Tab(text: "Completed"),
                        Tab(text: "To Be Read")
                      ],
                      children: [
                        BookGridWidget(books: libState.libraryBooks),
                        BookGridWidget(books: []),
                        BookGridWidget(books: []),
                      ],
                    );
                  }
                }))
              ],
            ),
          ),

          /*
          BlocBuilder<LibraryBloc, LibraryStruct>(
            builder: (BuildContext context, LibraryStruct libState) {
              List<ContentPanel> toReturn;
              if (libState.loadingStruct.isLoading) {
                toReturn = <ContentPanel>[
                  SolidPanel(
                      children: [LoadingItem()],
                      primary: Theme.of(context).canvasColor)
                ];
              } else {
                toReturn = <ContentPanel>[
                  SolidPanel(children: [
                    BlankPanel(height: 25),
                    PanelHeader("My Library"),
                    BlankPanel(height: 25),
                    TabbedPanel(
                      tabs: [
                        Tab(text: "Currently Reading"),
                        Tab(text: "Completed"),
                        Tab(text: "To Be Read")
                      ],
                      children: [
                        BookGrid(
                          books: [],
                        ),
                        Container(),
                        Container(),
                      ],
                    ),
                    DividerPanel(color: Theme.of(context).dividerColor),
                  ], primary: Theme.of(context).canvasColor)
                ];
              }
              return AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    child: Column(children: toReturn),
                  ));
            },
          ), */
        ));
  }
}
