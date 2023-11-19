import 'package:flutter/material.dart';

class PaginatedScrollViewWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _paginatedScrollViewWidgetState extends State<PaginatedScrollViewWidget> {
  late final ScrollController _paginatedScrollController;

  @override
  void initState() {
    this._paginatedScrollController = ScrollController();
    this._paginatedScrollController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
