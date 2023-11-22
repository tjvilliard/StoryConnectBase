import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/home_book_list_widget.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/book_list.dart';
import 'package:storyconnect/Pages/reading_hub/home/state/reading_home_bloc.dart';
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
    ReadingHomeBloc readingHomeBloc = context.read<ReadingHomeBloc>();
    readingHomeBloc.add(const FetchBooksEvent());
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
              title: "Reading Home",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: 500, minWidth: 250, maxHeight: 50),
                  child: const SearchBar(),
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(child: BlocBuilder<ReadingHomeBloc, ReadingHomeStruct>(
              builder: (BuildContext context, ReadingHomeStruct state) {
                return ListView.builder(

                    // add 1 to the number of
                    itemCount: state.mappedBooks.length + 2,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        Widget widgetToReturn;
                        if (state.loadingStruct.isLoading) {
                          widgetToReturn = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                style: Theme.of(context).textTheme.titleLarge,
                                "Continue Reading from your Library...",
                              ),
                              const SizedBox(height: 25),
                              Container(
                                  alignment: Alignment.center,
                                  height: 220,
                                  child: LoadingWidget(
                                    loadingStruct: state.loadingStruct,
                                  )),
                            ],
                          );
                        } else {
                          widgetToReturn = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                style: Theme.of(context).textTheme.titleLarge,
                                "Continue Reading from your Library...",
                              ),
                              const SizedBox(height: 25),
                              SizedBox(
                                  height: 220,
                                  child: BookListWidget(
                                      bookList: BookList(
                                    bookList:
                                        state.libraryBookMap.values.toList(),
                                  ))),
                            ],
                          );
                        }

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: widgetToReturn,
                        );
                      } else if (index == 1) {
                        Widget toReturn;
                        if (state.loadingStruct.isLoading) {
                          toReturn = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 25),
                              const Divider(),
                              const SizedBox(height: 25),
                              Text(
                                style: Theme.of(context).textTheme.titleLarge,
                                "All Books from Backend...",
                              ),
                              const SizedBox(height: 25),
                              Container(
                                  alignment: Alignment.center,
                                  height: 220,
                                  child: LoadingWidget(
                                    loadingStruct: state.loadingStruct,
                                  )),
                            ],
                          );
                        } else {
                          toReturn = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 25),
                              const Divider(),
                              const SizedBox(height: 25),
                              Text(
                                style: Theme.of(context).textTheme.titleLarge,
                                "All Books from Backend...",
                              ),
                              const SizedBox(height: 25),
                              SizedBox(
                                  height: 220,
                                  child: BookListWidget(
                                    bookList: BookList(
                                      bookList: state.allBooks,
                                    ),
                                  ))
                            ],
                          );
                        }
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: toReturn,
                        );
                      } else {
                        MapEntry<String, List<Book>> entry =
                            state.mappedBooks.entries.toList()[index];
                        String bookTag = entry.key;
                        List<Book> bookList = entry.value;

                        return BookList(bookList: bookList);
                      }
                    });
              },
            )),
          ]),
        )));
  }
}
