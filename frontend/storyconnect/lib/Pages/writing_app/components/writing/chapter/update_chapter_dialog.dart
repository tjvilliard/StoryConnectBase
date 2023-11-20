import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/chapter/delete_chapter_button.dart';
import 'package:storyconnect/Widgets/form_field.dart';

typedef OnSaveTitle = void Function(String title);

class UpdateChapterDialog extends StatefulWidget {
  final String title;
  final VoidCallback onDelete;
  final OnSaveTitle onSaveTitle;

  const UpdateChapterDialog({super.key, required this.title, required this.onDelete, required this.onSaveTitle});

  @override
  _UpdateChapterDialogState createState() => _UpdateChapterDialogState();
}

class _UpdateChapterDialogState extends State<UpdateChapterDialog> {
  late String title;

  @override
  void initState() {
    title = widget.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        clipBehavior: Clip.none, // Allows elements to be positioned outside the Dialog box
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: 400,
              minHeight: 250,
              maxHeight: 300,
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Update Chapter', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                CustomFormField(
                  initialValue: title,
                  onChanged: (value) => title = value,
                  label: 'Chapter Title',
                ),
                Wrap(
                  spacing: 8.0, // Spacing between buttons
                  alignment: WrapAlignment.spaceBetween, // Aligns the button groups
                  children: [
                    DeleteChapterButton(onDelete: widget.onDelete),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                        SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            widget.onSaveTitle(title);
                            Navigator.of(context).pop();
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 15,
            top: 10,
            child: IconButton.filledTonal(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
