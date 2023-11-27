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

  @override
  void initState() {
    super.initState();
    // Wait for the first frame to be drawn, then check the content height
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkContentHeight());
  }

  void _checkContentHeight() {
    final RenderBox renderBox = _unexpandedKey.currentContext?.findRenderObject() as RenderBox;
    if (renderBox.size.height > widget.maxHeight) {
      setState(() {
        _isOverflowing = true;
      });
    }
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
              child: FilledButton.tonal(
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
