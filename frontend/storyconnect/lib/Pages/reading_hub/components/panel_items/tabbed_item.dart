import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/panel_item.dart';

class TabbedPanel extends PanelItem {
  final List<Tab> tabs;

  final List<Widget> children;

  const TabbedPanel({super.key, required this.tabs, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(maxWidth: 800.0, maxHeight: 800),
        child: DefaultTabController(
          initialIndex: 0,
          length: tabs.length,
          child: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  decoration: const BoxDecoration(
                      border:
                          Border.symmetric(horizontal: BorderSide(width: 1.0))),
                  child: TabBar(
                    isScrollable: false,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    tabAlignment: TabAlignment.fill,
                    tabs: tabs,
                  ),
                )),
            body: TabBarView(
              children: children,
            ),
          ),
        ));
  }
}
