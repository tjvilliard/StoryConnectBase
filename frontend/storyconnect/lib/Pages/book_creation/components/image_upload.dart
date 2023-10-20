import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/book_creation/state/book_create_bloc.dart';

class ImageUpload extends StatelessWidget {
  const ImageUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 400),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlocBuilder<BookCreateBloc, BookCreateState>(
                builder: (context, state) {
              if (state.imageTitle != null) {
                return Text(state.imageTitle!);
              }

              return Text("No Image Selected");
            }),
            SizedBox(width: 15),
            ElevatedButton(
                onPressed: () {
                  context.read<BookCreateBloc>().add(UploadImageEvent());
                },
                child: Text("Upload Image")),
          ],
        ));
  }
}
