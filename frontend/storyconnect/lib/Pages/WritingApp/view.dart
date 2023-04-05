import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/WritingApp/custom_sliver.dart';

class WritingAppView extends StatelessWidget {
  const WritingAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Book",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          MenuBar(
              style: MenuStyle(
                  alignment: Alignment.centerLeft,
                  maximumSize: MaterialStatePropertyAll(Size(500, 200))),
              children: [
                MenuItemButton(
                    leadingIcon: Icon(FontAwesomeIcons.arrowRotateLeft),
                    child: Container()),
                MenuItemButton(
                    leadingIcon: Icon(FontAwesomeIcons.arrowRotateRight),
                    child: Container()),
                SizedBox(
                  width: 20,
                ),
                MenuItemButton(
                    leadingIcon: Icon(FontAwesomeIcons.comment),
                    child: Text("Comments")),
              ]),
          Flexible(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(minWidth: 80),
              ),
              Flexible(
                  child: Container(
                      constraints: BoxConstraints(maxWidth: 800),
                      child: CustomScrollView(
                        slivers: [
                          PageSliver(
                            itemExtent: 1100,
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (index == 20) {
                                  return null;
                                }
                                return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: .5),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(20),
                                    margin: EdgeInsets.all(20),
                                    child: TextField(
                                      maxLines: null,
                                      decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          hintText: 'Begin Writing...'),
                                    ));
                              },
                            ),
                          )
                        ],
                      ))),
            ],
          ))
        ],
      ),
    );
  }
}
