part of './book_form_fields.dart';

class BookFormField extends CustomFormField {
  BookFormField({required super.label, super.value, super.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: super.build(context));
  }
}
