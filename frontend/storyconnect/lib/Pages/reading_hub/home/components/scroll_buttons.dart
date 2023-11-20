import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/components/scroll_behavior/horizontal_scroll_behavior.dart';

ButtonStyle buttonShape = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
  borderRadius: BorderRadius.zero,
)));

class NavigateLeftButton extends StatelessWidget {
  final HorizontalScrollBehavior behaviorState;

  NavigateLeftButton({required this.behaviorState});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 1.0,
        child: Visibility(
            visible: this.behaviorState.leftScroll,
            child: Container(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                    style: buttonShape,
                    onPressed: () {
                      this.behaviorState.animateLeft();
                    },
                    child: HorizontalScrollBehavior.leftArrowIcon)),
            replacement: HorizontalScrollBehavior.zeroSpace));
  }
}

class NavigateRightButton extends StatelessWidget {
  final HorizontalScrollBehavior behaviorState;

  const NavigateRightButton({required this.behaviorState});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: this.behaviorState.rightScroll,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            print("Height of widget: ${constraints.maxHeight}");
            return Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(height: constraints.maxHeight),
                    child: ElevatedButton(
                        style: buttonShape,
                        onPressed: () {
                          this.behaviorState.animateRight();
                        },
                        child: HorizontalScrollBehavior.rightArrowIcon)));
          },
        ),
        replacement: HorizontalScrollBehavior.zeroSpace);
  }
}
