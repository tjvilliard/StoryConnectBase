import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';

typedef ContextCallback = BuildContext Function();

class NavigatorService {
  // Unfinished function to push a named route
  void pushNamed(
    String routeName, {
    List<Object>? kwargs,
    List<Object>? arguments,
    BuildContext? context,
    ContextCallback? contextCallback,
  }) {
    assert(context != null || contextCallback != null,
        'You must provide a context or a ContextCallback');

    final contextToUse = context ?? contextCallback!();
    Beamer.of(contextToUse).beamToNamed(routeName, data: arguments);
  }
}
