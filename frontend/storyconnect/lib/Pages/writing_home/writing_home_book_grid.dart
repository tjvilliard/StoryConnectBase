import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

///
/// The Book Layout Grid Component of the Writing Home Page.
/// Lists each book for writing and the option to write new books.
///
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
///
class WritingHomeGridState extends State<WritingHomeGridView> {
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
  ///
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

  ///
  /// Builds the Actual Gridview responisble for displaying our books.
  ///
  GridView _buildGrid(
      BuildContext context, WritingHomeStruct state, int addLoading) {
    return GridView.builder(
      /// The Gridview Grid Delegate, always Constant
      gridDelegate: this._writingBookGridDelegate,

      // The Number of books we need to pad out
      itemCount: state.books.length + addLoading,

      // List each book
      itemBuilder: (context, index) {
        // If we've reached the index limit,
        // stop adding books to the list
        if (index == state.books.length) {
          return Center(
              child: LoadingWidget(
            loadingStruct: state.loadingStruct,
          ));
        }

        // Else get the next book to add to the list
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
                textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          ));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: this.getGridBlocConsumer(context));
  }

  ///
  /// Creates the Grid State Manager for the writer home view,
  /// the Grid State Bloc manages state and opening a new book.
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
    }, buildWhen: (previous, current) {
      final loadingDiff = previous.loadingStruct != current.loadingStruct;
      final bookDiff = previous.books != current.books;
      return bookDiff || loadingDiff;
    }, builder: (context, state) {
      int addLoading = 0;
      if (state.loadingStruct.isLoading) {
        addLoading++;
      }

      return Container(
          padding: EdgeInsets.only(top: 50, left: 75, right: 75, bottom: 50),
          child: this._buildGrid(context, state, addLoading));
    });
  }

  void openBook(WritingHomeBloc state) {}
}
