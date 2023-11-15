import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/book_items/big_book.dart';

///
class BigBookListWidget extends StatefulWidget {
  final List<Book> books;

  BigBookListWidget({required this.books});

  @override
  _bigBookListWidgetState createState() =>
      _bigBookListWidgetState(books: this.books);
}

///
class _bigBookListWidgetState extends State<BigBookListWidget> {
  final List<Book> books;

  final ScrollController _scrollController = ScrollController();
  bool showScrollLeftButton = false;
  bool showScrollRightButton = true;

  _bigBookListWidgetState({required this.books});

  @override
  void initState() {
    if (this.books.length < 3) {
      this.showScrollRightButton = false;
    } else {
      this.showScrollRightButton = true;
    }

    this._scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          this.showScrollLeftButton = false;
        } else {
          this.showScrollRightButton = false;
        }
      } else {
        this.showScrollRightButton = true;
        this.showScrollLeftButton = true;
      }

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: SizedBox(
            width: 800,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse
                        }),
                    child: SingleChildScrollView(
                      controller: this._scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: this
                              .books
                              .map((book) => Container(
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
                        visible: this.showScrollLeftButton,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder()),
                                onPressed: () {
                                  this._scrollController.animateTo(
                                      this._scrollController.offset - 400,
                                      duration: Duration(milliseconds: 350),
                                      curve: Curves.easeIn);
                                },
                                child: Icon(Icons.arrow_left))),
                        replacement: SizedBox.shrink())),
                Positioned(
                    right: 1.0,
                    child: Visibility(
                        visible: this.showScrollRightButton,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder()),
                                onLongPress: () {},
                                onPressed: () {
                                  this._scrollController.animateTo(
                                      this._scrollController.offset + 400,
                                      duration: Duration(milliseconds: 350),
                                      curve: Curves.easeIn);
                                },
                                child: Icon(Icons.arrow_right))),
                        replacement: SizedBox.shrink()))
              ],
            )));
  }
}
