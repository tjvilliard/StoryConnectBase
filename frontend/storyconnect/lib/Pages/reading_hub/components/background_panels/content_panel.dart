import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/panel_items/panel_item.dart';

/// Panel of widgets with set behaviours and backgrounds.
abstract class ContentPanel extends StatelessWidget {
  const ContentPanel();
}

/// A panel of a set of book content on the reader view.
/// Header panels optionally contain a subject.
class FadedContentPanel extends ContentPanel {
  final List<Widget> children;
  final Color primary;
  final Color fade;

  const FadedContentPanel({
    required this.children,
    required this.primary,
    required this.fade,
  });

  static FadedContentPanel bigBookPanel(
      {required List<Book> books,
      required Color primary,
      required Color fade,
      required String title}) {
    List<Widget> panelItems = <Widget>[];

    return FadedContentPanel(
        children: panelItems, primary: primary, fade: fade);
  }

  /// Builds a panel of tagged Books.
  static FadedContentPanel taggedBookPanel(Map<String, List<Book>> children,
      Color primary, Color fade, String title, bool descript) {
    List<Widget> panelItems = <Widget>[];

    panelItems.add(PanelHeader(title));

    for (MapEntry<String, List<Book>> tag in children.entries) {
      panelItems.add(PanelSubtitle("Popular Books in ${tag.key}"));
      panelItems.add(BookListWidget(books: tag.value, descript: descript));
      panelItems.add(DividerPanel(color: Colors.black, thickness: 1.0));
    }

    return FadedContentPanel(
        children: panelItems, primary: primary, fade: fade);
  }

  /// Builds a panel with a single list of books, with a title and subtitle.
  static FadedContentPanel titledBookPanel(List<Book> books, Color primary,
      Color fade, String title, String subtitle, bool descript) {
    List<Widget> panelItems = <Widget>[];

    panelItems.add(PanelHeader(title));
    panelItems.add(PanelSubtitle(subtitle));
    panelItems.add(BookListWidget(books: books, descript: descript));

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
          stops: [0.0, .99],
        )),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: this.children));
  }
}
