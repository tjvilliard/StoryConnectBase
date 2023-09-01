import 'package:flutter/material.dart';

class TextSubmitFieldWidget extends StatefulWidget {

  TextSubmitFieldWidget(bool )

  @override
  State<StatefulWidget> createState() => _TextSubmitWidgetState();
}

class _TextSubmitWidgetState extends State<TextSubmitFieldWidget> {
  late bool _obscureText;
  late String _label;
  late InputDecoration textfieldDecoration;
  //
  final TextEditingController _controller = TextEditingController();

  

  _TextSubmitWidgetState(bool obscureText, String label) {
    this._obscureText = obscureText;
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this._controller,
      decoration: InputDecoration(),
      onChanged: (_) => setState(() {}),
      obscureText: true,
    );
  }

  ///
  /// Extract the contents of this text field.
  ///
  String contents() {
    return this._controller.text;
  }

  ///
  /// Display a message with the text field that notifies the user if something goes wrong.
  ///
  void notify(String message) {}
}
