import 'package:flutter/material.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';

class AppBarTextButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  static const double width = 105.0;

  const AppBarTextButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: CustomAppBar.height,
        width: AppBarTextButton.width,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
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

class AppBarIconButton extends StatelessWidget {
  final Icon icon;
  final void Function() onPressed;
  static const double width = 50.0;

  const AppBarIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext) {
    return Container(
      height: CustomAppBar.height,
      width: CustomAppBar.height,
      child: IconButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)))),
          icon: this.icon,
          onPressed: this.onPressed),
    );
  }
}
