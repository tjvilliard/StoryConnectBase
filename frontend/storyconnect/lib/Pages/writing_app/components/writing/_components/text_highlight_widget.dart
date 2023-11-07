import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_components/text_highlight_painter.dart';

class TextHighlightWidget extends StatefulWidget {
  final Widget child;

  const TextHighlightWidget({Key? key, required this.child}) : super(key: key);
  @override
  TextHighlightWidgetState createState() => TextHighlightWidgetState();
}

class TextHighlightWidgetState extends State<TextHighlightWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );

    _animation = Tween<double>(begin: 1, end: 1.1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WritingUIBloc, WritingUIState>(
        listener: (context, uiState) async {
      if (uiState.rectsToHighlight != null) {
        await _animationController.forward();
        await _animationController.reverse();
        _animationController.reset();
      }
    }, builder: (context, uiState) {
      print(uiState.rectsToHighlight);
      return CustomPaint(
          painter: CustomHighlightPainter(
            rects: uiState.rectsToHighlight ?? [],
            color: Colors.yellow.withOpacity(.8),
            scale: _animation.value,
          ),
          child: widget.child);
    });
  }
}
