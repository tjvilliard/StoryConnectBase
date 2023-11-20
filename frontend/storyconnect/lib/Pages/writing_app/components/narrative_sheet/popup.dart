import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/state/narrative_sheet_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/view.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';

class NarrativeSheetPopup extends PopupRoute<void> {
  final int bookId;
  NarrativeSheetPopup(this.bookId);

  @override
  Color? get barrierColor => Theme.of(navigator!.context).colorScheme.background;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return BlocProvider<NarrativeSheetBloc>(
        create: (context) => NarrativeSheetBloc(
              context.read<WritingRepository>(),
              bookId,
            ),
        child: Material(
            child: SafeArea(
                minimum: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.x,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )),
                    Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: NarrativeSheetView(),
                        )),
                  ],
                ))));
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}
