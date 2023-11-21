import 'package:flutter/material.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';

import 'package:storyconnect/Widgets/book_forms/audience_dropdown.dart';
import 'package:storyconnect/Widgets/book_forms/copyright_dropdown.dart';
import 'package:storyconnect/Widgets/book_forms/image_upload.dart';
import 'package:storyconnect/Widgets/book_forms/language_dropdown.dart';
import 'package:storyconnect/Widgets/form_field.dart';

part 'book_form_field.dart';

/// A collection of callbacks for the book form fields.
///
/// This is used to pass callbacks to the book form fields.
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

/// A collection of default values for the book form fields.
class BookFormFieldDefaults {
  final String? title;
  final String? synopsis;
  final LanguageConstant? language;
  final TargetAudience? targetAudience;
  final String? noImageSelectedText;
  final CopyrightOption? copyRight;

  const BookFormFieldDefaults({
    this.title,
    this.synopsis,
    this.language,
    this.targetAudience,
    this.noImageSelectedText,
    this.copyRight,
  });

  const BookFormFieldDefaults.empty()
      : this(
            title: null,
            synopsis: null,
            language: null,
            targetAudience: null,
            noImageSelectedText: null,
            copyRight: null);
}

/// A collection of form fields for creating or updating a book.
class BookFormFields extends StatelessWidget {
  final EdgeInsets padding = EdgeInsets.all(10);
  final String? selectedImageTitle;
  final BookFormFieldCallbacks callbacks;
  final BookFormFieldDefaults defaults;

  BookFormFields(
      {super.key,
      this.selectedImageTitle,
      required this.callbacks,
      this.defaults = const BookFormFieldDefaults.empty()});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookFormField(
          onChanged: callbacks.onTitleChanged,
          label: "Title",
          initialValue: defaults.title,
        ),
        SizedBox(height: 5),
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
                initialValue: defaults.language,
              ),
            ),
            Padding(
                padding: padding,
                child: AudienceDropdown(
                  onSelected: (value) => callbacks.onTargetAudienceChanged.call(value),
                  initialValue: defaults.targetAudience,
                )),
          ],
        ),
        SizedBox(height: 10),
        Padding(
            padding: padding,
            child: CopyrightDropdown(
              onSelected: (value) => callbacks.onCopyRightChanged.call(value),
              initialValue: defaults.copyRight,
            )),
        SizedBox(height: 20),
        ImageUpload(
          imageTitle: selectedImageTitle,
          noneSelectedText: defaults.noImageSelectedText,
          onImageSelect: () => callbacks.onImageChanged.call(),
        ),
        SizedBox(height: 20),
        BookFormField(
          maxLines: 5,
          maxLength: 500,
          onChanged: callbacks.onSynopsisChanged,
          initialValue: defaults.synopsis,
          label: "Book Synopsis",
        ),
      ],
    );
  }
}
