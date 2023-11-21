import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Widgets/app_nav/app_nav.dart';

class AppBarTextButton extends StatelessWidget {
  final Icon icon;
  final String text;
  final String uri;
  static const double width = 105.0;

  const AppBarTextButton({super.key, required this.text, required this.icon, required this.uri});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ConstrainedBox(
              constraints: const BoxConstraints(),
              child: TextButton.icon(
                icon: icon,
                label: Text(text),
                onPressed: () {
                  Beamer.of(context).beamToNamed(uri);
                },
              ))),
    );
  }
}

class AppBarIconButton extends StatelessWidget {
  final Icon icon;
  final void Function() onPressed;
  static const double width = 50.0;

  const AppBarIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CustomAppBar.height,
      width: CustomAppBar.height,
      child: IconButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)))),
          icon: icon,
          onPressed: onPressed),
    );
  }
}

class AppBarMenuButton extends StatelessWidget {
  final BuildContext context;
  final void Function() onPressed;
  final Widget child;

  const AppBarMenuButton({super.key, required this.context, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 200,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MenuItemButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)))),
            onPressed: onPressed,
            child: child,
          )),
    );
  }
}
