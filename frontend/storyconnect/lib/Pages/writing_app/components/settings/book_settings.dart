import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Pages/writing_app/components/settings/delete_book_button.dart';
import 'package:storyconnect/Pages/writing_app/components/settings/update_book_button.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Widgets/book_forms/book_form_fields.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

/// A dialog that allows the user to change the book settings.

class BookSettings extends StatelessWidget {
  final WritingUIBloc uiBloc;
  const BookSettings({
    super.key,
    required this.uiBloc,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: uiBloc,
        child: Dialog(
            child: Stack(children: [
          Container(
            constraints: BoxConstraints(maxWidth: 600, minHeight: 500),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Book Settings", style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(width: 15),
                    Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Icon(FontAwesomeIcons.book, size: 25, color: Theme.of(context).colorScheme.secondary))
                  ],
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(height: 10),
                  BlocBuilder<WritingUIBloc, WritingUIState>(builder: (context, state) {
                    if (state.loadingStruct.isLoading) return LoadingWidget(loadingStruct: state.loadingStruct);
                    if (state.bookEditorState == null)
                      return Text("No book was found", style: Theme.of(context).textTheme.displaySmall);
                    return BookFormFields(
                        defaults: BookFormFieldDefaults(
                          title: state.bookEditorState!.book.title,
                          noImageSelectedText: "Upload a new cover image (optional)",
                          synopsis: state.bookEditorState!.book.synopsis,
                          copyRight: copyrightOptionFromInt(state.bookEditorState!.book.copyright!),
                          language: languageConstantFromString(state.bookEditorState!.book.language!),
                        ),
                        callbacks: BookFormFieldCallbacks.empty());
                  }),
                  SizedBox(height: 10)
                ]),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 10,
                  children: [
                    DeleteBookButton(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FilledButton.tonal(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel")),
                        SizedBox(width: 10),
                        UpdateBookButton()
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ])));
  }
}
