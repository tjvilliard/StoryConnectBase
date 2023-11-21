import 'package:flutter/material.dart';

/// A custom form field.
///
/// This is a wrapper around a [TextFormField] with stylistic changes.
class CustomFormField extends StatelessWidget {
  final String label;
  final String? value;
  final String? initialValue;
  final int? maxLength;
  final int maxLines;
  final Function(String)? onChanged;
  final VoidCallback? onFieldSubmitted;
  final TextEditingController? controller;
  CustomFormField(
      {required this.label,
      this.value,
      this.onChanged,
      this.onFieldSubmitted,
      this.initialValue,
      this.maxLength,
      this.maxLines = 1,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
