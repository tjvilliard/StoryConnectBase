import 'package:flutter/material.dart';

enum TagConstant {
  genre(Colors.blue),
  age(Colors.green),
  state(Colors.yellow);

  const TagConstant(this.tag);
  final Color tag;
}
