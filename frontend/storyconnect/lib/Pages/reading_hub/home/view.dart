import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/home_book_list_widget.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/library_list.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';
import 'package:storyconnect/Widgets/header.dart';

///
class ReadingHomeView extends StatefulWidget {
  const ReadingHomeView({super.key});

  @override
  ReadingHomeState createState() => ReadingHomeState();
}

class ReadingHomeState extends State<ReadingHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(context: context),
        body: Center(
            child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.65,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            const Header(
                alignment: WrapAlignment.end,
                title: "Reading Home",
                trailing: SizedBox(
                  width: 250,
                  child: SearchBar(),
                )),
            Expanded(
                child: ListView.builder(
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return const BookListWidget(
                            bookList: LibraryBookList());
                      } else {
                        if (((index) % 2) != 0) {
                          return const Divider();
                        } else {
                          return Container();
                        }
                      }
                    })),
          ]),
        )));
  }
}
