import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String? value;
  final Function(String)? onChanged;
  final VoidCallback? onFieldSubmitted;

  CustomFormField(
      {required this.label, this.value, this.onChanged, this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
