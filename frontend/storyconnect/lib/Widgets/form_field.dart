import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String? value;
  final Function(String)? onChanged;

  CustomFormField({required this.label, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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

class CustomMultiLineFormField extends StatelessWidget {
  final String label;
  final String? value;
  final Function(String)? onChanged;

  CustomMultiLineFormField({required this.label, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: 1000,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          labelText: label,
        ));
  }
}
