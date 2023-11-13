import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/solid_panel.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/panel_item.dart';
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
        body: Center(child: Container(child:
            BlocBuilder<ReadingHomeBloc, ReadingHomeStruct>(
                builder: (BuildContext context, ReadingHomeStruct homeState) {
          List<Widget> toReturn;
          if (homeState.loadingStruct.isLoading) {
            toReturn = <Widget>[
              SolidPanel(
                  children: [LoadingItem()],
                  primary: Theme.of(context).canvasColor)
            ];
          } else {
            /// Build scrolling paginated view of book panels
            toReturn = <Widget>[];
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
