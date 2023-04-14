import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_navigation.dart';
import 'package:storyconnect/Pages/writing_app/writing/paging_view.dart';
import 'package:storyconnect/Pages/writing_app/writing_menubar.dart';

class WritingAppView extends StatelessWidget {
  const WritingAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          "Book",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          WritingMenuBar(),
          Flexible(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // where chapter navigation is displayed
              ChapterNavigation(),
              // Where pages are displayed
              Flexible(child: PagingView()),

              Container()
            ],
          ))
        ],
      ),
    );
  }
}
