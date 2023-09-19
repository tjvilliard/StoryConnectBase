import 'package:flutter/material.dart';

class CustomMultiLineFormField extends StatelessWidget {
  final String label;
  final String? value;
  final Function(String)? onChanged;
  final int? maxLength;
  final int? maxLines;
  static const int _defaultMaxLines = 5;

  CustomMultiLineFormField(
      {required this.label,
      this.value,
      this.onChanged,
      this.maxLength,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: TextInputType.multiline,
        maxLength: this.maxLength == null ? null : this.maxLength,
        maxLines: this.maxLines == null ? _defaultMaxLines : this.maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          labelText: label,
        ));
  }
}
