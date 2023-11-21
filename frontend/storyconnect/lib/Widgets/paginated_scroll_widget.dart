import 'package:flutter/material.dart';

class PaginatedScrollViewWidget extends StatefulWidget {
  const PaginatedScrollViewWidget({super.key});

  @override
  State<StatefulWidget> createState() => PaginatedScrollViewWidgetState();
}

class PaginatedScrollViewWidgetState extends State<PaginatedScrollViewWidget> {
  late final ScrollController _paginatedScrollController;

  @override
  void initState() {
    _paginatedScrollController = ScrollController();
    _paginatedScrollController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
