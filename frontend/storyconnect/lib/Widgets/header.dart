import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? child;
  final CrossAxisAlignment crossAxisAlignment;

  Header(
      {required this.title,
      required this.subtitle,
      this.leading,
      this.trailing,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          if (leading != null) leading!,
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                Text(title, style: Theme.of(context).textTheme.displaySmall),
                Text(subtitle, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
