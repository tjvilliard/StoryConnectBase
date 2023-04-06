import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/WritingApp/page_sliver.dart';
import 'package:storyconnect/Pages/WritingApp/writing_app_bloc.dart';
import 'package:storyconnect/Pages/WritingApp/writing_page.dart';

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
                      child: BlocBuilder<PageBloc, Map<int, String>>(
                          buildWhen: (previous, current) {
                        return previous.length != current.length;
                      }, builder: (context, state) {
                        return CustomScrollView(
                          slivers: [
                            PageSliver(
                              itemExtent: 1100,
                              delegate: SliverChildBuilderDelegate(
                                childCount:
                                    context.watch<PageBloc>().state.length,
                                (BuildContext context, int index) {
                                  return WritingPageView(
                                    index: index,
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      })))
            ],
          ))
        ],
      ),
    );
  }
}
