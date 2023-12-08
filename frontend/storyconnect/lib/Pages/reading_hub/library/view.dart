import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/book_grid_widget.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/tabbed_widget.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';
import 'package:storyconnect/Widgets/header.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  LibraryViewState createState() => LibraryViewState();
}

class LibraryViewState extends State<LibraryView> {
  bool initialLoad = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialLoad) {
        initialLoad = false;
        final libraryHomeBloc = context.read<LibraryBloc>();
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
                child: const Column(children: [
                  Header(
                    title: "Library",
                  ),
                  Expanded(
                      child: TabbedBookDisplayWidget(tabs: [
                    Tab(text: "Currently Reading"),
                    Tab(text: "Completed"),
                    Tab(text: "Unread")
                  ], children: [
                    BookGridWidget(
                      category: 1,
                    ),
                    BookGridWidget(
                      category: 2,
                    ),
                    BookGridWidget(
                      category: 3,
                    ),
                  ]))
                ]))));
  }
}
