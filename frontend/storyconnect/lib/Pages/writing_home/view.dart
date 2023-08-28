import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class WritingHomeView extends StatefulWidget {
  const WritingHomeView({Key? key}) : super(key: key);

  @override
  WritingHomeState createState() => WritingHomeState();
}

class WritingHomeState extends State<WritingHomeView> {
  final TextEditingController textController = TextEditingController();
  bool initialLoad = true;

  final ButtonStyle BookButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
        return RoundedRectangleBorder();
      }),
      minimumSize: MaterialStatePropertyAll<Size>(Size(100 * 3, 100 * 4)));

  final ButtonStyle LogoutButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
        return RoundedRectangleBorder();
      }),
      minimumSize: MaterialStatePropertyAll<Size>(Size(1.5 * 139, 139)));

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

  void create(BuildContext context) {
    final writingHomeBloc = context.read<WritingHomeBloc>();
    writingHomeBloc.add(
      CreateBookEvent(title: textController.text.trim()),
    );
    textController.text = "";
  }

  void openBook(WritingHomeBloc state) {}

  @override
  Widget build(BuildContext context) {
    Widget WriterViewHeader = Container(
        height: 139,
        color: Colors.white,
        alignment: Alignment.center,
        child: Stack(children: [
          Align(
              alignment: Alignment.center,
              child: Text(
                "StoryConnect",
                style: TextStyle(fontSize: 40),
              )),
          Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => {Beamer.of(context).beamToNamed(("/"))},
                style: LogoutButtonStyle,
                child: Text("Sign out", style: TextStyle(fontSize: 20)),
              ))
        ]));

    Widget WriterViewTitle = Container(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.only(left: 75, top: 50, bottom: 50),
            child: Text(
              "My Books",
              style: TextStyle(fontSize: 30),
            )));

    return Scaffold(
      body: BlocConsumer<WritingHomeBloc, WritingHomeStruct>(
        listener: (context, state) {
          if (state.bookToNavigate != null) {
            final url = "/writer/${state.bookToNavigate!.id}";
            Beamer.of(context).beamToNamed(url, data: {
              "book": state.bookToNavigate,
            });
          }
        },
        buildWhen: (previous, current) {
          final loadingDiff = previous.loadingStruct != current.loadingStruct;
          final bookDiff = previous.books != current.books;
          return bookDiff || loadingDiff;
        },
        builder: (context, state) {
          int addLoading = 0;
          if (state.loadingStruct.isLoading) {
            addLoading++;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WriterViewHeader,
              WriterViewTitle,

              //GridView of Books
              Flexible(
                  child: Container(
                      padding: EdgeInsets.only(left: 75, right: 75, bottom: 50),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            crossAxisSpacing: 25.0,
                            mainAxisSpacing: 25.0,
                            //Set Max size of Grid Item
                            mainAxisExtent: 400,
                            maxCrossAxisExtent: 300
                            //Set Max size of Grid Item
                            ),

                        itemCount: max(1, state.books.length),

                        //Fills out the books in book state
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            //Button indicates submission
                            return ElevatedButton(
                              onPressed: () {
                                state.loadingStruct.isLoading
                                    ? null
                                    : create(context);
                              },
                              style: BookButtonStyle,
                              child: Column(
                                children: [
                                  //Textfield is where submission text is handled.
                                  Padding(
                                      padding: EdgeInsets.only(top: 135),
                                      child: Icon(FontAwesomeIcons.plus,
                                          size: 50)),
                                  Padding(
                                      padding: EdgeInsets.only(top: 55),
                                      child: TextField(
                                        controller: textController,
                                        onSubmitted: (_) =>
                                            state.loadingStruct.isLoading
                                                ? null
                                                : create(context),
                                        decoration: InputDecoration(
                                            hintText: 'Enter New Book Title',
                                            suffixIcon: (IconButton(
                                                onPressed: textController.clear,
                                                icon: Icon(Icons.clear)))),
                                      )),
                                ],
                              ),
                            );
                          }

                          if (index == state.books.length) {
                            return Center(
                                child: LoadingWidget(
                              loadingStruct: state.loadingStruct,
                            ));
                          }

                          Book book = state.books[index];
                          return Align(
                              child: ElevatedButton(
                            onPressed: () {
                              final writingHomeBloc =
                                  context.read<WritingHomeBloc>();
                              writingHomeBloc.add(OpenBookEvent(book: book));
                            },
                            style: BookButtonStyle,
                            child: Text(book.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18)),
                          ));
                        },
                      ))),
            ],
          );
        },
      ),
    );
  }
}
