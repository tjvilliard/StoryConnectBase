import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';

import 'package:storyconnect/Pages/book_creation/state/book_create_bloc.dart';
import 'package:storyconnect/Widgets/book_forms/audience_dropdown.dart';
import 'package:storyconnect/Widgets/book_forms/copyright_dropdown.dart';
import 'package:storyconnect/Widgets/book_forms/image_upload.dart';
import 'package:storyconnect/Widgets/book_forms/language_dropdown.dart';
import 'package:storyconnect/Widgets/book_forms/synopsis_form_field.dart';
import 'package:storyconnect/Widgets/form_field.dart';

part 'book_form_field.dart';

class BookFormFieldCallbacks {
  final Function(String) onTitleChanged;
  final Function(String) onSynopsisChanged;
  final Function(LanguageConstant) onLanguageChanged;
  final Function(TargetAudience) onTargetAudienceChanged;
  final Function() onImageChanged;
  final Function(CopyrightOption) onCopyRightChanged;

  BookFormFieldCallbacks({
    required this.onTitleChanged,
    required this.onSynopsisChanged,
    required this.onLanguageChanged,
    required this.onTargetAudienceChanged,
    required this.onImageChanged,
    required this.onCopyRightChanged,
  });

  factory BookFormFieldCallbacks.empty() {
    return BookFormFieldCallbacks(
      onTitleChanged: (value) {},
      onSynopsisChanged: (value) {},
      onLanguageChanged: (value) {},
      onTargetAudienceChanged: (value) {},
      onImageChanged: () {},
      onCopyRightChanged: (value) {},
    );
  }
}

class BookFormFields extends StatelessWidget {
  final EdgeInsets padding = EdgeInsets.all(10);
  final String? selectedImageTitle;
  final BookFormFieldCallbacks callbacks;

  BookFormFields({super.key, this.selectedImageTitle, required this.callbacks});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookFormField(
          onChanged: (value) {
            context.read<BookCreateBloc>().add(TitleChangedEvent(title: value));
          },
          label: "Title",
        ),
        SizedBox(height: 10),
        Padding(
            padding: padding,
            child: Text("Help your readers get to know your book!",
                textAlign: TextAlign.left, style: Theme.of(context).textTheme.titleMedium)),
        Wrap(
          children: [
            Padding(
                padding: padding,
                child: LanguageDropdown(
                  onSelected: (value) => callbacks.onLanguageChanged.call(value),
                )),
            Padding(
                padding: padding,
                child: AudienceDropdown(
                  onSelected: (value) => callbacks.onTargetAudienceChanged.call(value),
                )),
          ],
        ),
        SizedBox(height: 10),
        Padding(
            padding: padding,
            child: CopyrightDropdown(
              onSelected: (value) => callbacks.onCopyRightChanged.call(value),
            )),
        SizedBox(height: 20),
        ImageUpload(
          imageTitle: selectedImageTitle,
          onImageSelect: () => callbacks.onImageChanged.call(),
        ),
        SizedBox(height: 20),
        SynopsisFormField(
          onChanged: (String value) {
            context.read<BookCreateBloc>().add(SynopsisChangedEvent(Synopsis: value));
          },
          label: "Book Synopsis",
        ),
      ],
    );
  }
}
