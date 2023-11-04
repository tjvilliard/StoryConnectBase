import 'package:flutter/material.dart';

///
class LibraryBook extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const LibraryBook({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  _libraryBookState createState() =>
      _libraryBookState(onPressed: this.onPressed, child: this.child);
}

///
class _libraryBookState extends State<LibraryBook> {
  bool showButtons = false;
  final VoidCallback onPressed;
  final Widget child;
  _libraryBookState({
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? _buttonStyle = ButtonStyle(
        //textStyle: MaterialStatePropertyAll(Theme.of(context).te),
        //overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        //backgroundColor: MaterialStatePropertyAll(Theme.of(context).focusColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            side: BorderSide(width: 1.0),
            borderRadius: BorderRadius.circular(10))));

    return Container(
        height: 270,
        width: (270.0 / 1.618) + 25,
        child: Card(
          elevation: 4,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: MouseRegion(
                  onEnter: (_) => setState(() {
                        this.showButtons = true;
                      }),
                  onExit: (_) => setState(() {
                        this.showButtons = false;
                      }),
                  cursor: SystemMouseCursors.click,
                  child: Stack(
                    children: [
                      child,
                      this.showButtons
                          ? Positioned.fill(
                              child: Material(
                                color: Theme.of(context).hoverColor,
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 32.0, horizontal: 16.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: OutlinedButton(
                                                style: _buttonStyle,
                                                onPressed: this.onPressed,
                                                child: Text("Start Reading")),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: OutlinedButton(
                                                style: _buttonStyle,
                                                onPressed: () => {},
                                                child: Text(
                                                    "Remove from Library")),
                                          ),
                                        ])),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ))),
        ));
  }
}
