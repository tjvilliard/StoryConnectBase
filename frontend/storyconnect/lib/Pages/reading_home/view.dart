import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_home/components/tagged_books_widget.dart';
import 'package:storyconnect/Pages/reading_home/reading_home_bloc.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';
import 'package:storyconnect/Widgets/header.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ReadingHomeView extends StatefulWidget {
  const ReadingHomeView({Key? key}) : super(key: key);

  @override
  ReadingHomeState createState() => ReadingHomeState();
}

class ReadingHomeState extends State<ReadingHomeView> {
  bool initialLoad = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialLoad) {
        initialLoad = false;
        final readingHomeBloc = context.read<ReadingHomeBloc>();
        readingHomeBloc.add(GetBooksEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(context: context),
        body: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Header(title: "Reading Home"),
                    Flexible(
                      child: BlocBuilder<ReadingHomeBloc, ReadingHomeStruct>(
                          builder: (context, state) {
                        Widget toReturn;
                        if (state.loadingStruct.isLoading) {
                          toReturn =
                              LoadingWidget(loadingStruct: state.loadingStruct);
                        } else {
                          toReturn = TaggedBooksListWidget(
                              taggedBooks: state.taggedBooks);
                        }
                        return AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: toReturn);
                      }),
                    )
                  ],
                ))));
  }
}
