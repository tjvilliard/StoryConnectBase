import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/components/book_items/big_book.dart';
import 'package:storyconnect/Pages/reading_hub/components/scroll_behavior/list.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class LibraryBookList extends BookList {
  LibraryBookList({required super.behaviorState});

  @override
  _libraryBookListState createState() =>
      _libraryBookListState(behaviorState: super.behaviorState);
}

class _libraryBookListState extends BookListState {
  _libraryBookListState({required super.behaviorState});

  @override
  void initState() {
    context.read<LibraryBloc>().add(GetLibraryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Building library book list");

    return BlocBuilder<LibraryBloc, LibraryStruct>(
        builder: (context, LibraryStruct libraryState) {
      // If our library books are still loading, return loading indicator.
      if (libraryState.loadingStruct.isLoading) {
        return Container(
          alignment: Alignment.center,
          child: LoadingWidget(loadingStruct: libraryState.loadingStruct),
        );
      }

      /// Return our list of library books.
      else {
        return ListView.builder(
          itemCount: libraryState.libraryBooks.length,
          controller: super.behaviorState.scrollController,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int index) {
            return BigBook(book: libraryState.libraryBooks[index]);
          },
        );
      }
    });
  }
}
