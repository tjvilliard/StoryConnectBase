import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/WritingApp/custom_sliver.dart';
import 'package:storyconnect/Pages/WritingApp/page_layout.dart';

class WritingAppView extends StatefulWidget {
  const WritingAppView({super.key});

  @override
  _WritingAppViewState createState() => _WritingAppViewState();
}

class _WritingAppViewState extends State<WritingAppView> {
  final Map<int, String> pages = {};
  final PageStructure pageStructure =
      PageStructure(style: TextStyle(fontSize: 20));

  final Map<int, TextEditingController> controllers = {};

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
          Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Row(children: [
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
              ])),
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
                                if (pages[index] == null && index != 0) {
                                  return null;
                                }

                                TextEditingController controller;

                                if (controllers[index] == null) {
                                  controller = TextEditingController();
                                  controllers[index] = controller;
                                } else {
                                  controller = controllers[index]!;
                                }
                                controller.text = pages[index] ?? "";

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
                                      onChanged: (value) {
                                        pages[index] = value;
                                        setState(() {
                                          pages.addAll(pageStructure.layout(
                                              pages: pages));
                                        });
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((timeStamp) {
                                          controllers[index]!.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: pages[index]!
                                                          .length));
                                        });
                                      },
                                      controller: controller,
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
