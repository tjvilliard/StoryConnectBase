import 'package:flutter/services.dart';

class PasteTextInputFormatter extends TextInputFormatter {
  final Function(String originalText, String pastedText) onPasted;

  PasteTextInputFormatter({required this.onPasted});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int difference = newValue.text.length - oldValue.text.length;

    // If the difference is greater than 1, it's likely that the text has been pasted
    if (difference > 1) {
      onPasted(newValue.text, newValue.text.substring(oldValue.text.length));
      return oldValue; // Prevent TextField update and onChanged from being called
    }
    return newValue; // Allow TextField update and onChanged to be called
  }
}
