import 'dart:ffi';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

///
/// The base view for all home pages, should contain tabs to navigate between
/// the writer pages, reader pages, and anything else that needs to be supported
/// State of other main home view items should probably be managed here as well.
///
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  //State object for the home view
  State createState() => HomeState();
}

///
/// Manages the State of our Home Page
///
class HomeState extends State<HomeView> {
  /// The Number of Tabs and Coresponding Views.
  static const int views = 4;

  /// The Placeholder Icon
  static const Icon placeholder = Icon(Icons.add_photo_alternate_outlined);

  AppBar _mainAppBar = AppBar(leading: placeholder, actions: []);

  bool _initialLoad = true;

  //Our Set of Tabs, shouldn't change
  static TabBar _mainAppTabBar =
      TabBar(tabs: [Tab(text: "Writing"), Tab(text: "Reading")]);

  TabBarView _tabViews = new TabBarView(children: []);

  // called when HomeState is first initialized
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (this._initialLoad) {
        this._initialLoad = false;
        final writingHomeBloc = context.read<WritingHomeBloc>();
        writingHomeBloc.add(GetBooksEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            child: Scaffold(appBar: this._mainAppBar, body: this._tabViews),
            length: HomeState.views));
  }
}
