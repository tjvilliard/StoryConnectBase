import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/home_book_list_widget.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/library_list.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/sample_list.dart';
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
                          return BookListWidget(bookList: LibraryBookList());
                        } else {
                          if (((index) % 2) != 0) {
                            return Divider();
                          } else {
                            return BookListWidget(bookList: SampleBookList());
                          }
                        }
                      },
                      childCount: 15,
                    )),
                  ],
                ))));
  }
}
