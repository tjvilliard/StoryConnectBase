import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String? value;
  final String? initialValue;
  final int? maxLength;
  final int maxLines;
  final Function(String)? onChanged;
  final VoidCallback? onFieldSubmitted;

  CustomFormField(
      {required this.label,
      this.value,
      this.onChanged,
      this.onFieldSubmitted,
      this.initialValue,
      this.maxLength,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      maxLength: maxLength,
      initialValue: initialValue,
      onFieldSubmitted: (value) {
        onFieldSubmitted?.call();
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        labelText: label,
      ),
    );
  }
}
