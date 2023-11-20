import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/settings/book_settings.dart';

class BookSettingsButton extends StatelessWidget {
  const BookSettingsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: () {
        showDialog(context: context, builder: (context) => BookSettings());
      },
      icon: Icon(
        FontAwesomeIcons.gear,
        color: theme.colorScheme.onBackground,
      ),
    );
  }
}
