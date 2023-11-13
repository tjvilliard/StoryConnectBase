import 'package:flutter/material.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Services/Authentication/firebase_helper.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class DisplayNameLoaderWidget extends StatefulWidget {
  final String uid;
  final TextStyle? style;

  DisplayNameLoaderWidget({required this.uid, this.style});

  @override
  _DisplayNameLoaderWidgetState createState() =>
      _DisplayNameLoaderWidgetState();
}

class _DisplayNameLoaderWidgetState extends State<DisplayNameLoaderWidget> {
  String? displayName;

  static final _displayNameCache = <String, String>{};

  @override
  void initState() {
    super.initState();
    _loadDisplayName();
  }

  void _loadDisplayName() {
    final cachedName = _displayNameCache[widget.uid];
    if (cachedName != null) {
      setState(() {
        displayName = cachedName;
      });
    } else {
      FirebaseHelper.getDisplayName(widget.uid).then((String? fetchedName) {
        if (fetchedName != null) {
          setState(() {
            displayName = fetchedName;
            _displayNameCache[widget.uid] = fetchedName;
          });
        } else {
          setState(() {
            displayName = "Unknown";
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: displayName == null
          ? LoadingWidget(loadingStruct: LoadingStruct.loading(true))
          : Padding(
              padding: EdgeInsets.all(5),
              child: Text(displayName!,
                  style: widget.style, key: ValueKey('name'))),
    );
  }
}
