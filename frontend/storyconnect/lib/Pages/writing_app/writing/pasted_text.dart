import 'dart:collection';

import 'package:flutter/services.dart';

final class LinkedTextEditingValue<T extends TextEditingValue>
    extends LinkedListEntry<LinkedTextEditingValue<T>> {
  T value;
  LinkedTextEditingValue(this.value);
}

/// A [TextInputFormatter] that keeps track of the history of the text field,
/// allowing for undo and redo, up to the most recent 100 changes.
class RedoUndoInputFormatter extends TextInputFormatter {
  final LinkedList _history =
      LinkedList<LinkedTextEditingValue<TextEditingValue>>();

  final _redoStack = <LinkedTextEditingValue<TextEditingValue>>[];

  RedoUndoInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue == newValue) {
      return newValue;
    }
    _history.add(LinkedTextEditingValue(newValue));
    if (_history.length > 100) {
      _history.first.unlink();
    }
    return newValue;
  }
}
