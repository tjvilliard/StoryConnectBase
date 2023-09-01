import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/home_page/base_appbar.dart';
import 'package:storyconnect/Pages/writing_home/components/create_button.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';

import '../../theme.dart';
import 'writing_home_book_grid.dart';

class WritingHomeView extends StatefulWidget {
  const WritingHomeView({Key? key}) : super(key: key);

  @override
  //Initialize view state
  WritingHomeState createState() => WritingHomeState();
}

///
/// Represents the State of the Writing Home Page
///
class WritingHomeState extends State<WritingHomeView> {
  bool initialLoad = true;

  //Initialize state of widget
  @override
  void initState() {
    super.initState();

    final User? current_user = FirebaseAuth.instance.currentUser;

    if (current_user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (initialLoad) {
          initialLoad = false;
          final writingHomeBloc = context.read<WritingHomeBloc>();
          writingHomeBloc.add(GetBooksEvent());
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Beamer.of(context).beamToNamed("/");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoryConnect Writing Home View',
      theme: myTheme,
      home: Scaffold(
          appBar: baseAppBar,
          body: Column(
            children: [
              CreateBookButton(onPressed: () {
                // TODO: Add urls to a constants file
                Beamer.of(context).beamToNamed("/writer/create_book");
              }),
              Expanded(child: WritingHomeGridView())
            ],
          )),
    );
  }
}
