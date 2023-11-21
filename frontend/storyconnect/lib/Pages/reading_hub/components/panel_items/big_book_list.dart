import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/book_items/big_book.dart';

///
class BigBookListWidget extends StatefulWidget {
  final List<Book> books;

  const BigBookListWidget({super.key, required this.books});

  @override
  BigBookListWidgetState createState() => BigBookListWidgetState();
}

///
class BigBookListWidgetState extends State<BigBookListWidget> {
  List<Book> get books => widget.books;

  final ScrollController _scrollController = ScrollController();
  bool showScrollLeftButton = false;
  bool showScrollRightButton = true;

  @override
  void initState() {
    if (books.length < 3) {
      showScrollRightButton = false;
    } else {
      showScrollRightButton = true;
    }

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          showScrollLeftButton = false;
        } else {
          showScrollRightButton = false;
        }
      } else {
        showScrollRightButton = true;
        showScrollLeftButton = true;
      }

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: SizedBox(
            width: 800,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: books
                              .map((book) => SizedBox(
                                  height: 200,
                                  width: 400.0,
                                  child: Card(
                                      elevation: 0,
                                      child: BigBook(
                                        book: book,
                                      ))))
                              .toList()),
                    )),
                Positioned(
                    left: 1.0,
                    child: Visibility(
                        visible: showScrollLeftButton,
                        replacement: const SizedBox.shrink(),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                                onPressed: () {
                                  _scrollController.animateTo(_scrollController.offset - 400,
                                      duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
                                },
                                child: const Icon(Icons.arrow_left))))),
                Positioned(
                    right: 1.0,
                    child: Visibility(
                        visible: showScrollRightButton,
                        replacement: const SizedBox.shrink(),
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                                onLongPress: () {},
                                onPressed: () {
                                  _scrollController.animateTo(_scrollController.offset + 400,
                                      duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
                                },
                                child: const Icon(Icons.arrow_right)))))
              ],
            )));
  }
}
