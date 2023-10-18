import 'package:flutter/material.dart';

enum TagConstant {
  Genre(Colors.blue),
  Age(Colors.green),
  State(Colors.yellow);

  const TagConstant(this.tag);
  final Color tag;
}
