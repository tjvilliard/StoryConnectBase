import 'package:flutter/material.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';

class AppBarButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  static const double width = 105.0;

  const AppBarButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: CustomAppBar.height,
        width: AppBarButton.width,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0)))),
              child: Text(this.text),
              onPressed: this.onPressed,
            )));
  }
}
