import 'package:flutter/material.dart';

/// A header for a form.
class Header extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? child;
  final WrapAlignment alignment;

  const Header(
      {super.key, required this.title,
      this.subtitle,
      this.leading,
      this.trailing,
      this.alignment = WrapAlignment.spaceBetween,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Wrap(
        alignment: alignment,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) Padding(padding: const EdgeInsets.only(top: 5, right: 10), child: leading!),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.displaySmall),
                  if (subtitle != null) Text(subtitle!, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
          if (trailing == null) Container(),
          if (trailing != null) Padding(padding: const EdgeInsets.only(top: 5, left: 10), child: trailing!),
        ],
      ),
    );
  }
}
