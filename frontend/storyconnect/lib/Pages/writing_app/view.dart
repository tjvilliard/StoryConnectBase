import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_navigation.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/paging_view.dart';
import 'package:storyconnect/Pages/writing_app/writing_menubar.dart';

class WritingAppView extends StatefulWidget {
  const WritingAppView({super.key});

  @override
  _WritingAppViewState createState() => _WritingAppViewState();
}

class _WritingAppViewState extends State<WritingAppView> {
  bool firstLoaded = true;
  @override
  void initState() {
    if (firstLoaded) {
      firstLoaded = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context
            .read<ChapterBloc>()
            .add(LoadEvent(pageBloc: context.read<PageBloc>()));
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.home_filled),
              onPressed: () {
                BeamerDelegate beamer = Beamer.of(context);
                if (beamer.canBeamBack) {
                  Beamer.of(context).beamBack();
                } else {
                  Beamer.of(context).beamToNamed("/writer");
                }
              },
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Book",
              style: Theme.of(context).textTheme.displayLarge,
            )
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          WritingMenuBar(),
          Flexible(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // where chapter navigation is displayed
              ChapterNavigation(),
              // Where pages are displayed
              Flexible(child: PagingView()),

              Container()
            ],
          ))
        ],
      ),
    );
  }
}
