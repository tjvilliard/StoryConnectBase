import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/book_grid_widget.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/tabbed_widget.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
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
                const Header(
                  title: "Library",
                ),
                Expanded(child: BlocBuilder<LibraryBloc, LibraryStruct>(
                    builder: (BuildContext context, LibraryStruct libState) {
                  if (libState.loadingStruct.isLoading) {
                    return LoadingWidget(loadingStruct: libState.loadingStruct);
                  } else {
                    return TabbedBookDisplayWidget(
                      tabs: const [
                        Tab(text: "Currently Reading"),
                        Tab(text: "Completed"),
                        Tab(text: "To Be Read")
                      ],
                      children: [
                        BookGridWidget(books: libState.libraryBooks),
                        const BookGridWidget(books: []),
                        const BookGridWidget(books: []),
                      ],
                    );
                  }
                }))
              ],
            ),
          ),

          /*
          
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
