import 'package:flutter/material.dart';
import 'package:storyconnect/Widgets/form_field_multiline.dart';

class SynopsisFormField extends CustomMultiLineFormField {
  SynopsisFormField({required super.label, super.value, super.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: super.build(context));
  }
}
