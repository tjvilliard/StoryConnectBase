import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/big_book_list.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/solid_panel.dart';
import 'package:storyconnect/Pages/reading_hub/components/sample_books.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/home_book_list_widget.dart';
import 'package:storyconnect/Pages/reading_hub/components/scroll_behavior/horizontal_scroll_behavior.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/home_scroll_behavior.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/library_list.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';

///
class ReadingHomeView extends StatefulWidget {
  const ReadingHomeView({Key? key}) : super(key: key);

  @override
  _readingHomeState createState() => _readingHomeState();
}

class _readingHomeState extends State<ReadingHomeView> {
  bool initialLoad = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialLoad) {
        initialLoad = false;
      }
    });

    super.initState();
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
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                      addAutomaticKeepAlives: true,
                      (BuildContext context, int index) {
                        if (index == 0) {
                          /// Class
                          /// -- Scroll Behaviors
                          /// -- BLOC
                          /// -- Components

                          HorizontalScrollBehavior scrollBehavior =
                              HorizontalScrollBehaviorImpl1(
                                  scrollAnimationDistance: 400,
                                  scrollAnimationDuration_MilliSeconds: 350);

                          return BookListWidget(
                            behaviorState: scrollBehavior,
                            bookList:
                                LibraryBookList(behaviorState: scrollBehavior),
                          );
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
                ))));
  }
}
