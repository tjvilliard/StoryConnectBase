part of 'book_creation_form_fields.dart';

class BookCreationFormField extends CustomFormField {
  BookCreationFormField({required super.label, super.value, super.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: super.build(context));
  }
}
