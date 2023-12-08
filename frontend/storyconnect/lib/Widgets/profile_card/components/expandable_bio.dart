import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpandableBioWidget extends StatefulWidget {
  final String bioText;
  final double maxHeight;

  const ExpandableBioWidget({
    super.key,
    required this.bioText,
    this.maxHeight = 100.0, // default height threshold
  });

  @override
  ExpandableBioWidgetState createState() => ExpandableBioWidgetState();
}

class ExpandableBioWidgetState extends State<ExpandableBioWidget> {
  bool isExpanded = false;
  final GlobalKey _unexpandedKey = GlobalKey();
  bool _isOverflowing = false;
  Timer? _layoutCheckTimer;
  int _layoutRetryCount = 0;
  final int _maxLayoutRetries = 10;

  @override
  void initState() {
    super.initState();
    _layoutCheckTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _checkContentHeight();
    });
  }

  void _checkContentHeight() {
    if (_layoutRetryCount >= _maxLayoutRetries) {
      _layoutCheckTimer?.cancel();
      return;
    }

    final RenderBox? renderBox = _unexpandedKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      if (renderBox.size.height > widget.maxHeight) {
        setState(() {
          _isOverflowing = true;
        });
      }
      _layoutCheckTimer?.cancel(); // Cancel timer as layout is successful
    } else {
      _layoutRetryCount++;
    }
  }

  @override
  void dispose() {
    _layoutCheckTimer?.cancel();
    super.dispose();
  }

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        isExpanded ? _buildExpandedBio() : _buildCollapsedBio(),
        if (_isOverflowing)
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: toggleExpanded,
                child: Text(isExpanded ? "Show Less" : "Show More"),
              )),
      ],
    );
  }

  Widget _buildExpandedBio() {
    return MarkdownBody(data: widget.bioText, onTapLink: onClickLink);
  }

  void onClickLink(String url, String? _, String __) {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: url,
    );

    launchUrl(emailLaunchUri);
  }

  Widget _buildCollapsedBio() {
    return ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.transparent],
            stops: [0.8, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: SizedBox(
            height: widget.maxHeight,
            width: double.infinity,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: MarkdownBody(key: _unexpandedKey, data: widget.bioText, onTapLink: onClickLink),
              ),
            )));
  }
}
