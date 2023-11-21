import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  CustomSearchBarState createState() => CustomSearchBarState();
}

class CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      constraints: const BoxConstraints(
        minWidth: 100,
        maxWidth: 400,
        minHeight: 40,
        maxHeight: 40,
      ),
      child: const Row(
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
