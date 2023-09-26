import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_home/reading_home_bloc.dart';
import 'package:storyconnect/Pages/writing_home/components/view_profile_button.dart';
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
        appBar: AppBar(),
        body: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Header(
                      title: "Reading Home",
                      subtitle: "",
                      leading: ViewProfileButton(),
                    ),
                    Flexible(
                      child: BlocBuilder<ReadingHomeBloc, ReadingHomeStruct>(
                          builder: (context, state) {
                        Widget toReturn;
                        if (state.loadingStruct.isLoading) {
                          toReturn =
                              LoadingWidget(loadingStruct: state.loadingStruct);
                        } else {
                          toReturn = Column(
                            children: [],
                          );
                        }
                        return AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: toReturn);
                      }),
                    )
                    // Get Content Tags and
                    // Associated Books for each tag.
                  ],
                ))));
  }
}
