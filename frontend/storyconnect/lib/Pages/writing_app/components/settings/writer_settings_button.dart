import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/settings/book_settings.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';

class BookSettingsButton extends StatelessWidget {
  final WritingUIBloc uiBloc;
  const BookSettingsButton({
    super.key,
    required this.uiBloc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => BlocProvider.value(value: uiBloc, child: const BookSettings()));
      },
      icon: Icon(
        FontAwesomeIcons.gear,
        color: theme.colorScheme.onBackground,
      ),
    );
  }
}
