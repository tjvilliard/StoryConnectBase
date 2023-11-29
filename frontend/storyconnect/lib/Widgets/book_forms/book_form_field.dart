part of './book_form_fields.dart';

/// A form field for the book form.
///
/// This is used to create a form field for the book form.
class BookFormField extends CustomFormField {
  const BookFormField(
      {super.key, required super.label, super.value, super.onChanged, super.initialValue, super.maxLines = 1, super.maxLength});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: super.build(context));
  }
}
