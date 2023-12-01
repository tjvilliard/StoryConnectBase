import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Widgets/book_forms/book_form_fields.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/settings/delete_book_button.dart';
import 'package:storyconnect/Pages/writing_app/components/settings/update_book_button.dart';

class BookSettings extends StatelessWidget {
  const BookSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Stack(children: [
      Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title section
            _buildTitleSection(context),
            const SizedBox(height: 5),
            // Scrollable content section
            Expanded(
              child: SingleChildScrollView(
                child: Center(child: _buildScrollableContent(context)),
              ),
            ),
            const SizedBox(height: 5),
            // Buttons section
            _buildButtonsSection(context),
          ],
        ),
      ),
      Positioned(
          top: 10,
          right: 20,
          child: IconButton.filledTonal(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<WritingUIBloc>().add(ClearUpdateBookEvent());
              },
              icon: const Icon(FontAwesomeIcons.x)))
    ]));
  }

  Widget _buildTitleSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Book Settings",
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(width: 15),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            FontAwesomeIcons.book,
            size: 25,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableContent(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(
      builder: (context, state) {
        if (state.loadingStruct.isLoading) {
          return LoadingWidget(loadingStruct: state.loadingStruct);
        } else if (state.bookEditorState == null || state.book == null) {
          return Text(
            "No book was found",
            style: Theme.of(context).textTheme.displaySmall,
          );
        } else {
          return BookFormFields(
            selectedImageTitle: state.bookEditorState!.imageTitle,
            defaults: BookFormFieldDefaults(
              title: state.bookEditorState!.book.title,
              noImageSelectedText: "Upload a new cover image (optional)",
              synopsis: state.bookEditorState!.book.synopsis,
              copyRight: copyrightOptionFromInt(state.bookEditorState!.book.copyright),
              language: languageConstantFromString(state.bookEditorState!.book.language),
              targetAudience: targetAudienceFromIndex(state.bookEditorState!.book.targetAudience),
            ),
            callbacks: BookFormFieldCallbacks(
              onTitleChanged: (title) => context.read<WritingUIBloc>().add(UpdateBookTitleEvent(title: title)),
              onSynopsisChanged: (synopsis) =>
                  context.read<WritingUIBloc>().add(UpdateBookSynopsisEvent(synopsis: synopsis)),
              onLanguageChanged: (language) =>
                  context.read<WritingUIBloc>().add(UpdateBookLanguageEvent(language: language.label)),
              onTargetAudienceChanged: (targetAudience) => context
                  .read<WritingUIBloc>()
                  .add(UpdateBookTargetAudienceEvent(targetAudience: targetAudience.index)),
              onCopyRightChanged: (copyright) =>
                  context.read<WritingUIBloc>().add(UpdateBookCopyrightEvent(copyright: copyright.index)),
              onImageChanged: () => context.read<WritingUIBloc>().add(SelectUpdatedBookCoverEvent()),
            ),
          );
        }
      },
    );
  }

  Widget _buildButtonsSection(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 10,
      children: [
        const DeleteBookButton(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.tonal(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<WritingUIBloc>().add(ClearUpdateBookEvent());
              },
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 10),
            const UpdateBookButton(),
          ],
        ),
      ],
    );
  }
}
