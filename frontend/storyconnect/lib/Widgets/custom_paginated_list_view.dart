import 'package:flutter/material.dart';

///
class CustomPaginatedListView extends StatefulWidget {
  ///
  CustomPaginatedListView() : super();

  @override
  _customPaginatedListViewState createState() =>
      _customPaginatedListViewState();
}

///
class _customPaginatedListViewState extends State<CustomPaginatedListView> {
  ///
  _customPaginatedListViewState() : super();

  ScrollController _scrollController = ScrollController();

  bool _isLoading = true;

  @override
  void initState() {
    this._scrollController.addListener(() {
      if (this._scrollController.position.maxScrollExtent ==
          this._scrollController.position.pixels) {
        if (!this._isLoading) {
          this._isLoading = !this._isLoading;
          //load more data...
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: this._scrollController,
      itemCount: 0,
      itemBuilder: (context, index) {},
    );
  }
}
