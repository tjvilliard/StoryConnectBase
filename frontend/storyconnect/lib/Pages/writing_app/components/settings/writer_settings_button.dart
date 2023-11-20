import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/settings/book_settings.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';

class BookSettingsButton extends StatelessWidget {
  final WritingUIBloc uiBloc;
  const BookSettingsButton({
    Key? key,
    required this.uiBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => BookSettings(
                  uiBloc: uiBloc,
                ));
      },
      icon: Icon(
        FontAwesomeIcons.gear,
        color: theme.colorScheme.onBackground,
      ),
    );
  }
}
