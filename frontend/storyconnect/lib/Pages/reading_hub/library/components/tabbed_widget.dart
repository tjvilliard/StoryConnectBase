import 'package:flutter/material.dart';

class TabbedBookDisplayWidget extends StatelessWidget {
  final List<Tab> tabs;

  final List<Widget> children;

  TabbedBookDisplayWidget({required this.tabs, required this.children});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: this.tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide(width: 1.0))),
              child: TabBar(
                isScrollable: false,
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                tabAlignment: TabAlignment.fill,
                tabs: this.tabs,
              ),
            )),
        body: TabBarView(
          children: this.children,
        ),
      ),
    );
  }
}
