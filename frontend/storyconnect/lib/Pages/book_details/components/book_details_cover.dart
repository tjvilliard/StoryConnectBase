import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/book_details/state/book_details_bloc.dart';
import 'package:storyconnect/Widgets/image_loader.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class BookDetailsCover extends StatelessWidget {
  const BookDetailsCover({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookDetailsBloc, BookDetailsState>(
        builder: (context, state) {
      Widget toReturn;
      if (state.bookDetailsLoadingStruct.isLoading) {
        toReturn = SizedBox(
            height: 325 * 1.33,
            width: 325,
            child: LoadingWidget(
              loadingStruct: state.bookDetailsLoadingStruct,
            ));
      } else if (state.book == null) {
        toReturn = const SizedBox(
            height: 325 * 1.33,
            width: 325,
            child: Icon(Icons.book, size: 200.0));
      } else {
        toReturn = BookDetailsCoverLoader(book: state.book);
      }
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: toReturn,
      );
    });
  }
}

class BookDetailsCoverLoader extends StatefulWidget {
  static const double coverWidth = 350.0;
  final Book? book;

  const BookDetailsCoverLoader({super.key, required this.book});

  @override
  State<StatefulWidget> createState() => BookDetailsCoverLoaderState();
}

class BookDetailsCoverLoaderState extends State<BookDetailsCoverLoader> {
  String? url;

  @override
  void initState() {
    getImage(widget.book!.cover);
    super.initState();
  }

  Widget _imagePlaceHolder() {
    return const Column(children: [
      SizedBox(
        height: BookDetailsCoverLoader.coverWidth * 1.33,
        width: BookDetailsCoverLoader.coverWidth,
        child: Icon(Icons.book, size: 200),
      )
    ]);
  }

  Future<void> getImage(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) {
      if (mounted) {
        setState(() {
          url = "";
        });
      }

      return;
    }
    Reference ref = FirebaseStorage.instance.ref().child(relativePath);
    final result = await ref.getDownloadURL();
    if (mounted) {
      setState(() {
        url = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (url == null || url!.isEmpty) _imagePlaceHolder(),
      if (url != null && url!.isNotEmpty)
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ImageLoader(
                url: url!,
                fit: BoxFit.cover,
                constraints: const BoxConstraints(
                  maxHeight: 325 * 1.33,
                  minHeight: 325 * 1.33,
                  maxWidth: 325,
                  minWidth: 325,
                ))),
    ]);
  }
}
