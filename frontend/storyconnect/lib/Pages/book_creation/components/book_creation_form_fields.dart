import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/book_creation/components/audience_dropdown.dart';
import 'package:storyconnect/Pages/book_creation/components/language_dropdown.dart';
import 'package:storyconnect/Pages/book_creation/state/book_create_bloc.dart';
import 'package:storyconnect/Widgets/form_field.dart';

part 'book_creation_form_field.dart';

class BookCreationFormFields extends StatelessWidget {
  final EdgeInsets padding = EdgeInsets.all(10);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BookCreationFormField(
        //   onChanged: (value) {
        //     context
        //         .read<BookCreateBloc>()
        //         .add(AuthorChangedEvent(author: value));
        //   },
        //   label: "Author",
        // ),
        BookCreationFormField(
          onChanged: (value) {
            context.read<BookCreateBloc>().add(TitleChangedEvent(title: value));
          },
          label: "Title",
        ),
        SizedBox(height: 20),
        Padding(
            padding: padding,
            child: Text("Let us know more about your book",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleMedium)),
        Wrap(
          children: [
            Padding(padding: EdgeInsets.all(10), child: LanguageDropdown()),
            Padding(padding: padding, child: AudienceDropdown()),
          ],
        )
      ],
    );
  }
}
