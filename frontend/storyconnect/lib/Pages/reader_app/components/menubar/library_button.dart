import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class LibraryMenuButton extends StatefulWidget {
  final int bookId;

  LibraryMenuButton({required this.bookId});

  @override
  _libraryMenuButtonState createState() =>
      _libraryMenuButtonState(bookId: this.bookId);
}

class _libraryMenuButtonState extends State<LibraryMenuButton> {
  late bool inLibrary;
  final int bookId;

  _libraryMenuButtonState({required this.bookId});

  @override
  void initState() {
    context.read<LibraryBloc>().add(GetLibraryEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryStruct>(
      builder: (BuildContext context, LibraryStruct state) {
        this.inLibrary = context
            .read<LibraryBloc>()
            .state
            .libraryBooks
            .where((element) => (element.id == this.bookId))
            .isNotEmpty;

        return Container(
            height: 40,
            width: this.inLibrary ? 180 : 130,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
            child: state.loadingStruct.isLoading
                ? Transform.scale(
                    scale: .6,
                    child: LoadingWidget(loadingStruct: state.loadingStruct))
                : InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    onTap: () {
                      if (this.inLibrary) {
                        context
                            .read<LibraryBloc>()
                            .add(RemoveBookEvent(bookId: this.bookId));
                      } else {
                        context
                            .read<LibraryBloc>()
                            .add(AddBookEvent(bookId: this.bookId));
                      }
                      this.inLibrary = !this.inLibrary;
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox.adaptive(
                            value: this.inLibrary,
                            side: MaterialStateBorderSide.resolveWith(
                                (states) => BorderSide(
                                    width: 2.0,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                            onChanged: (_) {}),
                        Text(
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                            this.inLibrary
                                ? "Remove from library"
                                : "Add to library"),
                      ],
                    )));
      },
    );
  }
}
