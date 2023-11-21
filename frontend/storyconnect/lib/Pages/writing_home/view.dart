import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:storyconnect/Pages/writing_home/bool_list_widget.dart';
import 'package:storyconnect/Pages/writing_home/components/create_button.dart';
import 'package:storyconnect/Pages/writing_home/components/view_profile_button.dart';
import 'package:storyconnect/Pages/writing_home/components/writing_search_bar.dart';
import 'package:storyconnect/Pages/writing_home/state/writing_home_bloc.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';
import 'package:storyconnect/Widgets/header.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class WritingHomeWidget extends StatefulWidget {
  const WritingHomeWidget({super.key});

  @override
  //Initialize view state
  WritingHomeWidgetState createState() => WritingHomeWidgetState();
}

///
/// Represents the State of the Writing Home Page
///
class WritingHomeWidgetState extends State<WritingHomeWidget> {
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
      appBar: CustomAppBar(
        context: context,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Header(
                title: "Writing Home",
                subtitle: "",
                leading: ViewProfileButton(),
                trailing: CreateBookButton(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500, minWidth: 250, maxHeight: 50),
                      child: const WritingSearchBar()),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: BlocBuilder<WritingHomeBloc, WritingHomeState>(
                  builder: (context, state) {
                    Widget toReturn;
                    if (state.loadingStruct.isLoading) {
                      toReturn = LoadingWidget(loadingStruct: state.loadingStruct);
                    } else if (state.searchingBooks.isNotEmpty) {
                      toReturn = BookListWidget(
                        books: state.searchingBooks,
                      );
                    } else if (state.query?.isNotEmpty == false && state.searchingBooks.isEmpty) {
                      toReturn = Center(
                        child: Text("No Books Found", style: Theme.of(context).textTheme.displaySmall),
                      );
                    } else {
                      toReturn = BookListWidget(
                        books: state.books,
                      );
                    }
                    return AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: toReturn);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
