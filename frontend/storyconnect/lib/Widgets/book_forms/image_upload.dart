import 'package:flutter/material.dart';

/// A dropdown for the copyright book form.
class ImageUpload extends StatelessWidget {
  static final String _noneSelectedText = "No image selected";
  final String? noneSelectedText;
  final String? imageTitle;
  final VoidCallback onImageSelect;

  const ImageUpload({super.key, this.imageTitle, required this.onImageSelect, this.noneSelectedText});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 400),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (imageTitle != null)
              Flexible(
                  child: Text(
                imageTitle!,
                maxLines: 1,
              )),
            if (imageTitle == null)
              Flexible(
                  child: Text(
                noneSelectedText ?? _noneSelectedText,
                maxLines: 2,
                textAlign: TextAlign.center,
              )),
            SizedBox(width: 15),
            ElevatedButton(onPressed: () => onImageSelect.call(), child: Text("Upload Image")),
          ],
        ));
  }
}
