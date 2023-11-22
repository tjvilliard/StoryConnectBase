import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/home_book_list_widget.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/book_list.dart';
import 'package:storyconnect/Pages/reading_hub/home/state/reading_home_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';
import 'package:storyconnect/Widgets/header.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

///
class ReadingHomeView extends StatefulWidget {
  const ReadingHomeView({super.key});

  @override
  ReadingHomeState createState() => ReadingHomeState();
}

class ReadingHomeState extends State<ReadingHomeView> {
  @override
  void initState() {
    LibraryBloc bloc = context.read<LibraryBloc>();
    bloc.add(GetLibraryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(context: context),
        body: Center(
            child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.65,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            const Header(
                alignment: WrapAlignment.end,
                title: "Reading Home",
                trailing: SizedBox(
                  width: 250,
                  child: SearchBar(),
                )),
            Expanded(child: BlocBuilder<ReadingHomeBloc, ReadingHomeStruct>(
              builder: (BuildContext context, ReadingHomeStruct state) {
                return ListView.builder(

                    // add 1 to the number of
                    itemCount: state.mappedBooks.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return BlocBuilder<LibraryBloc, LibraryStruct>(
                          builder: (context, LibraryStruct libraryState) {
                            Widget widgetToReturn;
                            if (libraryState.loadingStruct.isLoading) {
                              widgetToReturn = LoadingWidget(
                                loadingStruct: libraryState.loadingStruct,
                              );
                            } else {
                              widgetToReturn = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    "Continue Reading from your Library...",
                                  ),
                                  const SizedBox(height: 25),
                                  SizedBox(
                                      height: 220,
                                      child: BookListWidget(
                                          bookList: BookList(
                                        bookList: libraryState.libraryBooks,
                                      ))),
                                ],
                              );
                            }

                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: widgetToReturn,
                            );
                          },
                        );
                      } else {
                        if (((index) % 2) != 0) {
                          return const Divider();
                        } else {
                          MapEntry<String, List<Book>> entry =
                              state.mappedBooks.entries.toList()[index];
                          String bookTag = entry.key;
                          List<Book> bookList = entry.value;

                          return BookList(bookList: bookList);
                        }
                      }
                    });
              },
            )),
          ]),
        )));
  }
}
