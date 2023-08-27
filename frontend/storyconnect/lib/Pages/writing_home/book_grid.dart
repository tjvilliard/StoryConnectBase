import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class WritingHomeGridView extends StatefulWidget {
  const WritingHomeGridView({Key? key}) : super(key: key);

  @override
  //Initialize view state
  WritingHomeGridState createState() => WritingHomeGridState();
}

///
/// Manages the State of the Writing Home page, specifically the only
/// component with state, the Grid. The Grid lists all of the books, and
/// updates when a new book is added.
class WritingHomeGridState extends State<WritingHomeGridView> {
  final TextEditingController _textController = TextEditingController();
  bool initialLoad = true;

  final SliverGridDelegate _writingBookGridDelegate =
      SliverGridDelegateWithMaxCrossAxisExtent(
          crossAxisSpacing: 25.0,
          mainAxisSpacing: 25.0,
          //Set Max size of Grid or Book Item
          mainAxisExtent: 400,
          maxCrossAxisExtent: 300
          //Set Max size of Grid or Book Item
          );

  ///
  /// Manages the Visible Properites of a Book Button
  final ButtonStyle _bookButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
        return RoundedRectangleBorder();
      }),
      minimumSize: MaterialStatePropertyAll<Size>(Size(100 * 3, 100 * 4)));

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
    return Scaffold(body: this.getGridBlocConsumer(context));
  }

  ///
  ///
  BlocConsumer<WritingHomeBloc, WritingHomeStruct> getGridBlocConsumer(
      BuildContext context) {
    return BlocConsumer<WritingHomeBloc, WritingHomeStruct>(
        listener: (context, state) {
      if (state.bookToNavigate != null) {
        final url = "/writer/${state.bookToNavigate!.id}";
        Beamer.of(context).beamToNamed(url, data: {
          "book": state.bookToNavigate,
        });
      }
    },

        // Conditions for rebuilding the Widget
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

      return Container(
          padding: EdgeInsets.only(left: 75, right: 75, bottom: 50),

          //The grid we are laying out our books on
          child: GridView.builder(
            /// The Gridview Grid Delegate, always Constant
            gridDelegate: this._writingBookGridDelegate,

            // The Number of books we need to pad out
            itemCount: state.books.length + addLoading,

            // List each book
            itemBuilder: (context, index) {
              // The book at index 0 should not be a new book, but rather an option to add a new book
              if (index == 0) {
                //Button indicates submission
                return ElevatedButton(
                  onPressed: () {
                    state.loadingStruct.isLoading ? null : create(context);
                  },
                  style: this._bookButtonStyle,
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 135),
                          child: Icon(FontAwesomeIcons.plus, size: 50)),
                      Padding(
                          padding: EdgeInsets.only(top: 55),
                          child: TextField(
                            controller: this._textController,
                            onSubmitted: (_) => state.loadingStruct.isLoading
                                ? null
                                : create(context),
                            decoration: InputDecoration(
                                hintText: 'Enter New Book Title',
                                suffixIcon: (IconButton(
                                    onPressed: this._textController.clear,
                                    icon: Icon(Icons.clear)))),
                          )),
                    ],
                  ),
                );
              }

              // If we've reached the index limit,
              // stop adding books to the list
              if (index == state.books.length) {
                return Center(
                    child: LoadingWidget(
                  loadingStruct: state.loadingStruct,
                ));
              }

              // Get the next book to add to the list
              else {
                Book book = state.books[index];
                return Align(
                    child: ElevatedButton(
                  onPressed: () {
                    final writingHomeBloc = context.read<WritingHomeBloc>();
                    writingHomeBloc.add(OpenBookEvent(book: book));
                  },
                  style: _bookButtonStyle,
                  child: Text(book.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18)),
                ));
              }
            },
          ));
    });
  }

  ///
  /// Handles the Front End Side of Creating a new Book
  ///
  void create(BuildContext context) {
    // Get the current state of the writing home bloc
    final writingHomeBloc = context.read<WritingHomeBloc>();

    // Insert our new book with our title into the bloc
    writingHomeBloc.add(
      CreateBookEvent(title: this._textController.text.trim()),
    );

    // Reset the state of the text controller
    this._textController.text = "";
  }

  void openBook(WritingHomeBloc state) {}
}
