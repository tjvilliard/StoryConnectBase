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
  //Initialize view state
  WritingHomeState createState() => WritingHomeState();
}

///
/// Represents the State of the Writing Home Page
///
class WritingHomeState extends State<WritingHomeView> {
  final TextEditingController textController = TextEditingController();
  bool initialLoad = true;

  // End Const Widgets

  // The Book Button Placeholder
  final ButtonStyle BookButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
        return RoundedRectangleBorder();
      }),
      minimumSize: MaterialStatePropertyAll<Size>(Size(100 * 3, 100 * 4)));

  // The Logout Button Placeholder
  final ButtonStyle LogoutButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
        return RoundedRectangleBorder();
      }),
      minimumSize: MaterialStatePropertyAll<Size>(Size(1.5 * 139, 139)));

  // End Const Widgets

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

  // Creates a new book
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
        //Listner for navigating to a book
        listener: (context, state) {
          if (state.bookToNavigate != null) {
            final url = "/writer/${state.bookToNavigate!.id}";
            Beamer.of(context).beamToNamed(url, data: {
              "book": state.bookToNavigate,
            });
          }
        },
        //
        buildWhen: (previous, current) {
          final loadingDiff = previous.loadingStruct != current.loadingStruct;
          final bookDiff = previous.books != current.books;
          return bookDiff || loadingDiff;
        },

        // What we are actually building with the widget
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
              //The actual list of books, represented as a gridview
              Flexible(
                  child: Container(
                      padding: EdgeInsets.only(left: 75, right: 75, bottom: 50),

                      //The grid we are laying out our books on
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            crossAxisSpacing: 25.0,
                            mainAxisSpacing: 25.0,
                            //Set Max size of Grid or Book Item
                            mainAxisExtent: 400,
                            maxCrossAxisExtent: 300
                            //Set Max size of Grid or Book Item
                            ),

                        // The Number of books we need to pad out
                        itemCount: state.books.length + addLoading,

                        //The Itembuilder fills out the books
                        //
                        itemBuilder: (context, index) {
                          //For the first book in our list, we have an option to create a new book
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
