import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/solid_panel.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/panel_item.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/tabbed_item.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';

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
        body: Center(child: BlocBuilder<LibraryBloc, LibraryStruct>(
          builder: (BuildContext context, LibraryStruct libState) {
            List<ContentPanel> toReturn;
            if (libState.loadingStruct.isLoading) {
              toReturn = <ContentPanel>[
                SolidPanel(primary: Theme.of(context).canvasColor, children: const [LoadingItem()])
              ];
            } else {
              toReturn = <ContentPanel>[
                SolidPanel(primary: Theme.of(context).canvasColor, children: [
                  const BlankPanel(height: 25),
                  PanelHeader("My Library"),
                  const BlankPanel(height: 25),
                  TabbedPanel(
                    tabs: const [Tab(text: "Currently Reading"), Tab(text: "Completed"), Tab(text: "To Be Read")],
                    children: [
                      BookGrid(
                        books: libState.libraryBooks,
                      ),
                      Container(),
                      Container(),
                    ],
                  ),
                  DividerPanel(color: Theme.of(context).dividerColor),
                ])
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
        )));
  }
}
