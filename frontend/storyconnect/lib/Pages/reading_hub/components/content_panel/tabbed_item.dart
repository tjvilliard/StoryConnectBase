import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/components/content_panel/panel_item.dart';

class TabbedPanel extends PanelItem {
  final List<Tab> tabs;

  final List<Widget> children;

  TabbedPanel({required this.tabs, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 800.0, maxHeight: 800),
        child: DefaultTabController(
          initialIndex: 0,
          length: this.tabs.length,
          child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border.symmetric(horizontal: BorderSide(width: 1.0))),
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
        ));
  }
}
