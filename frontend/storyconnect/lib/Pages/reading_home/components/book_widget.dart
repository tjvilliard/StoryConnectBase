import 'dart:math';

import 'package:flutter/material.dart';

/// Possible Colors for Book Placeholder Colors
enum BookPlaceholderColors {
  Red(Colors.red),
  Orange(Colors.orange),
  Yellow(Colors.yellow),
  Green(Colors.green),
  Blue(Colors.blue),
  Indigo(Colors.indigo),
  Violet(Colors.deepPurple),
  Purple(Colors.purple),
  Black(Colors.black),
  Grey(Colors.white);

  const BookPlaceholderColors(this.color);
  final Color color;
}

extension randomBookColor on BookPlaceholderColors {
  static BookPlaceholderColors pickAColor() {
    var rand = Random();
    return BookPlaceholderColors
        .values[rand.nextInt(BookPlaceholderColors.values.length)];
  }
}

/// Encapsulates all of the visuals of the Book Description Icon
class BookCardWidget extends StatelessWidget {
  /// Represents the total height of this card.
  static double CardHeight = 200;

  /// Represents the total width of this card.
  static double CardWidth = 400;

  static double IconSize = 100;

  /// The Title of this book
  late final String _title;

  /// The Author of this book.
  late final String _author;

  /// The Synopsis of this book.
  late final String _synopsis;

  /// Placeholder Image For Book Cover.
  Widget _imagePlaceHolder() {
    return SizedBox(
      height: 100,
      width: 100,
      child: Icon(
        Icons.book,
        color: randomBookColor.pickAColor().color,
        size: 100,
      ),
    );
  }

  BookCardWidget(
      {required String author, required String title, String synopsis = ""})
      : super() {
    this._title = title;
    this._author = author;
    this._synopsis = synopsis;
  }

  /// Wraps the Widget's Title Text
  RichText _wrapTitle(String text) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      )
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(0.0),
        child: Container(
            height: CardHeight,
            width: CardWidth,
            child: Card(
                margin: EdgeInsets.zero,
                elevation: 2,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 2.0, right: 2.0, bottom: 2.0, top: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(children: [
                          this._imagePlaceHolder(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              this._wrapTitle(this._title),
                              Text(this._author),
                              Text("Synopsis Placeholder"),
                            ],
                          )
                        ]),
                        Text("Tag Placeholder"),
                      ],
                    )))));
  }
}
