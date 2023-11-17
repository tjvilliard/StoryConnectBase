import 'package:flutter/material.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _searchViewState createState() => _searchViewState();
}

class _searchViewState extends State<SearchView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context),
      body: Container(),
    );
  }
}
