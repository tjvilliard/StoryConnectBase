import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSearchBar extends StatefulWidget {
  @override
  _customSearchBarState createState() => _customSearchBarState();
}

class _customSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      constraints: BoxConstraints(
        minWidth: 100,
        maxWidth: 400,
        minHeight: 40,
        maxHeight: 40,
      ),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.magnifyingGlass),
          Expanded(
              child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
            ),
          )),
        ],
      ),
    );
  }
}
