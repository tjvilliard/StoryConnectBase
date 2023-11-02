import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/content_panel/panel_item.dart';

/// Panel of widgets with set behaviours and backgrounds.
abstract class ContentPanel extends StatelessWidget {
  const ContentPanel();
}

/// A material horizontal divider to be used between content panels.
class ContentDivider extends ContentPanel {
  /// The color of this divider.
  final Color color;

  /// The thickness of the line drawn by the divider.
  final double? thickness;

  ContentDivider({required this.color, this.thickness = null});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: this.color,
      thickness: this.thickness,
      height: 0.0,
      indent: 0,
      endIndent: 0,
    );
  }
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

class SolidContentPanel extends ContentPanel {
  final List<Widget> children;
  final Color primary;

  const SolidContentPanel({
    required this.children,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: this.primary),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: this.children));
  }
}
