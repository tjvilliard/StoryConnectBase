import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The input widget for using feedback mode comment.
class FeedbackInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(minHeight: 100.0),
          child: Card(
              margin: EdgeInsets.all(4.0),
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Column(children: [
                  // Sentiment Panel

                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Container(
                                    constraints:
                                        BoxConstraints(minHeight: 60.0),
                                    child: TextField(
                                      controller: TextEditingController(),
                                      onChanged: (value) {},
                                      minLines: 1,
                                      maxLines: 5,
                                      maxLength: 1000,
                                      decoration: InputDecoration(
                                          hintText: "Write a Comment..."),
                                    ))),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.send),
                                    )))
                          ]))
                ]),
              )),
        ));
  }
}
