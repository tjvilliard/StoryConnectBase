import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_creation/components/save_book_button.dart';
import 'package:storyconnect/Pages/writing_creation/state/book_create_bloc.dart';

class WritingCreationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(child:
        BlocBuilder<BookCreateBloc, BookCreateState>(builder: (context, state) {
      return Column(
        children: [
          TextField(
            onChanged: (value) {
              context
                  .read<BookCreateBloc>()
                  .add(AuthorChangedEvent(author: value));
            },
            decoration: InputDecoration(
              labelText: "Author",
            ),
          ),
          TextField(
            onChanged: (value) {
              context
                  .read<BookCreateBloc>()
                  .add(TitleChangedEvent(title: value));
            },
            decoration: InputDecoration(
              labelText: "Title",
            ),
          ),
          SaveBookButton()
        ],
      );
    }));
  }
}
