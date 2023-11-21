import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/big_book.dart';
import 'package:storyconnect/Pages/reading_hub/home/behaviors/horizontal_scroll_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/list.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class LibraryBookList extends BookList {
  const LibraryBookList({super.key});

  @override
  LibraryBookListState createState() => LibraryBookListState();
}

class LibraryBookListState extends BookListState {
  LibraryBookListState();

  @override
  void initState() {
    context.read<LibraryBloc>().add(GetLibraryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        return BlocBuilder<HorizontalScrollBehaviorBloc, HorizontalScrollState>(
            builder: (BuildContext context, HorizontalScrollState state) {
          return ListView.builder(
            itemCount: libraryState.libraryBooks.length,
            controller: state.scrollController,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, int index) {
              return BigBook(book: libraryState.libraryBooks[index]);
            },
          );
        });
      }
    });
  }
}
