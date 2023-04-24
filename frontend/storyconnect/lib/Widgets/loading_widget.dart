import 'package:flutter/material.dart';
import 'package:storyconnect/Models/loading_struct.dart';

class LoadingWidget extends StatelessWidget {
  final LoadingStruct loadingStruct;
  const LoadingWidget({super.key, required this.loadingStruct});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (loadingStruct.message != null)
          Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(loadingStruct.message!)),
        CircularProgressIndicator()
      ],
    );
  }
}
