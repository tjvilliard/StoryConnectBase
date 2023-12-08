import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class LibraryMenuButton extends StatefulWidget {
  final int bookId;

  const LibraryMenuButton({super.key, required this.bookId});

  @override
  LibraryMenuButtonState createState() => LibraryMenuButtonState();
}

class LibraryMenuButtonState extends State<LibraryMenuButton> {
  late bool inLibrary;
  int get bookId => widget.bookId;

  @override
  void initState() {
    context.read<LibraryBloc>().add(const FetchLibraryBooksEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (BuildContext context, LibraryState state) {
        inLibrary = context
            .read<LibraryBloc>()
            .state
            .libraryBookMap
            .values
            .where((element) => (element.id == bookId))
            .isNotEmpty;

        return Container(
            height: 40,
            width: inLibrary ? 180 : 130,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
            child: state.libraryLoadingStruct.isLoading
                ? Transform.scale(
                    scale: .6,
                    child: LoadingWidget(
                        loadingStruct: state.libraryLoadingStruct))
                : InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    onTap: () {
                      if (inLibrary) {
                        context
                            .read<LibraryBloc>()
                            .add(RemoveBookFromLibraryEvent(bookId: bookId));
                      } else {
                        context
                            .read<LibraryBloc>()
                            .add(AddBookToLibraryEvent(bookId: bookId));
                      }
                      inLibrary = !inLibrary;
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox.adaptive(
                            value: inLibrary,
                            side: MaterialStateBorderSide.resolveWith(
                                (states) => BorderSide(
                                    width: 2.0,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                            onChanged: (_) {}),
                        Text(
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                            inLibrary
                                ? "Remove from library"
                                : "Add to library"),
                      ],
                    )));
      },
    );
  }
}
