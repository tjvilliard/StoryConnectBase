import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_home/components/content_panel/panel_item.dart';

abstract class ContentPanel extends StatelessWidget {
  const ContentPanel();
}

/// A panel of a set of book content on the reader view.
/// Header panels optionally contain a subject.
class FadedContentPanel extends ContentPanel {
  final List<PanelItem> children;
  final Color primary;
  final Color fade;

  const FadedContentPanel({
    required this.children,
    required this.primary,
    required this.fade,
  });

  /// Builds a panel of tagged Books.
  static FadedContentPanel taggedBookPanel(Map<String, List<Book>> children,
      Color primary, Color fade, String Title) {
    List<PanelItem> panelItems = <PanelItem>[];

    for (MapEntry<String, List<Book>> tag in children.entries) {
      panelItems.add(PanelSubtitle(tag.key));
      panelItems.add(BookList(books: tag.value));
    }

    return FadedContentPanel(
        children: panelItems, primary: primary, fade: fade);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [this.primary, this.fade],
          stops: [0.0, 1.0],
        )),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: this.children));
  }
}
