import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

///
///The base view for all home pages, should contain tabs to navigate between
///the writer pages, reader pages, and anything else that needs to be supported
///
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  //State object for the home view
  //
  HomeState createState() => HomeState();
}

///
/// Manages the State of our Home Page
///
class HomeState extends State<HomeView> {
  bool initialLoad = true;

  TabBar tabs = TabBar(tabs: [Tab(text: )]);

  // called when initialized
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialLoad) {
        initialLoad = false;
        final writingHomeBloc = context.read<WritingHomeBloc>();
        writingHomeBloc.add(GetBooksEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //
        home: DefaultTabController(child: Scaffold(), length: 2));
  }
}
