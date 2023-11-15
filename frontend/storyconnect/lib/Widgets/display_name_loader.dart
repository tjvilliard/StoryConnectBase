import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Services/Authentication/firebase_helper.dart';

class DisplayNameLoaderWidget extends StatefulWidget {
  final int? id;
  final TextStyle? style;

  DisplayNameLoaderWidget({required this.id, this.style});

  @override
  _DisplayNameLoaderWidgetState createState() =>
      _DisplayNameLoaderWidgetState();
}

class _DisplayNameLoaderWidgetState extends State<DisplayNameLoaderWidget> {
  String? displayName;
  String loadingText = "Loading.";
  Timer? loadingTextTimer;
  Timer? cacheUpdatedTimer;

  static const String unknown = "Unknown";

  static final _displayNameCache = <int, String>{};
  static final _loadingInProgress = <int>{};

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      _loadDisplayName(widget.id!);
      _startLoadingTextTimer();
    } else {
      displayName = unknown;
      if (kDebugMode) {
        print("DisplayNameLoaderWidget: id is null");
      }
      return;
    }
  }

  @override
  void dispose() {
    loadingTextTimer?.cancel();
    _loadingInProgress.remove(widget.id);
    super.dispose();
  }

  void _startCacheUpdatedTimer(int id) {
    cacheUpdatedTimer = Timer.periodic(Duration(milliseconds: 25), (Timer t) {
      if (_displayNameCache.containsKey(id)) {
        cacheUpdatedTimer?.cancel();
        loadingTextTimer?.cancel();
        if (mounted) {
          setState(() {
            displayName = _displayNameCache[id];
          });
        }

        loadingTextTimer?.cancel();
        return;
      }
    });
  }

  void _startLoadingTextTimer() {
    loadingTextTimer = Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      if (mounted) {
        setState(() {
          if (loadingText == 'Loading.') {
            loadingText = 'Loading..';
          } else if (loadingText == 'Loading..') {
            loadingText = 'Loading...';
          } else {
            loadingText = 'Loading.';
          }
        });
      }
    });
  }

  void _loadDisplayName(int id) async {
    if (_displayNameCache.containsKey(id)) {
      loadingTextTimer?.cancel();
      if (mounted) {
        setState(() {
          displayName = _displayNameCache[id];
        });
      }
    } else if (!_loadingInProgress.contains(id)) {
      _loadingInProgress.add(id);

      final fetchedName = await FirebaseHelper.getDisplayName(id);
      if (fetchedName != null) {
        _displayNameCache[id] = fetchedName;
        if (mounted) {
          setState(() {
            displayName = fetchedName;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            displayName = unknown;
          });
        }
      }

      _loadingInProgress.remove(id);
      loadingTextTimer?.cancel();
    } else {
      _startCacheUpdatedTimer(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: displayName == null
          ? Text(loadingText, style: widget.style)
          : Text(displayName!, style: widget.style),
    );
  }
}
