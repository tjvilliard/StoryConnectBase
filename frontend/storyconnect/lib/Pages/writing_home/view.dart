import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_home/bool_list_widget.dart';
import 'package:storyconnect/Pages/writing_home/components/create_button.dart';
import 'package:storyconnect/Pages/writing_home/components/view_profile_button.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';
import 'package:storyconnect/Widgets/header.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

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
    return Scaffold(
      appBar: baseAppBar,
      body: Column(
        children: [
          CreateBookButton(onPressed: () {
            // TODO: Add urls to a constants file
            Beamer.of(context).beamToNamed("/writer/create_book");
          }),
          Expanded(child: WritingHomeGridView())
        ],
      ),
    );
  }
}
