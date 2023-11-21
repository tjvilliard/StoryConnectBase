import 'package:flutter/material.dart';
import 'package:storyconnect/Models/loading_struct.dart';

/// A widget for displaying a loading indicator.
///
/// This widget is used to display a loading indicator with an optional message.
class LoadingWidget extends StatelessWidget {
  final LoadingStruct loadingStruct;
  final bool short;
  const LoadingWidget({super.key, required this.loadingStruct, this.short = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (loadingStruct.message != null)
          Padding(
              padding: short ? EdgeInsets.symmetric(vertical: 10) : EdgeInsets.symmetric(vertical: 15),
              child: Text(
                loadingStruct.message!,
                textAlign: TextAlign.center,
              )),
        short
            ? Container(
                width: 100,
                child: LinearProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            : CircularProgressIndicator(),
      ],
    );
  }
}
