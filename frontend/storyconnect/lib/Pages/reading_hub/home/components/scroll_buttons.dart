import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reading_hub/home/behaviors/horizontal_scroll_bloc.dart';

class NavigateLeftButton extends StatefulWidget {
  const NavigateLeftButton({super.key});

  @override
  State<StatefulWidget> createState() => LeftButtonState();
}

class LeftButtonState extends State<NavigateLeftButton> {
  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonShape = ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context)
            .buttonTheme
            .colorScheme!
            .background
            .withOpacity(0.3)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        )));

    return BlocBuilder<HorizontalScrollBehaviorBloc, HorizontalScrollState>(
      builder: (BuildContext context, HorizontalScrollState state) {
        return Visibility(
            visible: state.leftScroll,
            replacement: const SizedBox.shrink(),
            child:
                LayoutBuilder(builder: (context, BoxConstraints constraints) {
              return Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          height: constraints.maxHeight),
                      child: ElevatedButton(
                          style: buttonShape,
                          onPressed: () {
                            BlocProvider.of<HorizontalScrollBehaviorBloc>(
                                    context)
                                .add(ScrollLeftEvent());
                          },
                          child: const Icon(FontAwesomeIcons.arrowLeft))));
            }));
      },
    );
  }
}

class NavigateRightButton extends StatefulWidget {
  const NavigateRightButton({super.key});

  @override
  RightButtonState createState() => RightButtonState();
}

class RightButtonState extends State<NavigateRightButton> {
  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonShape = ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context)
            .buttonTheme
            .colorScheme!
            .background
            .withOpacity(0.3)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        )));

    return BlocBuilder<HorizontalScrollBehaviorBloc, HorizontalScrollState>(
      builder: (BuildContext context, HorizontalScrollState state) {
        return Visibility(
            visible: state.rightScroll,
            replacement: const SizedBox.shrink(),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Align(
                  alignment: Alignment.centerRight,
                  child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          height: constraints.maxHeight),
                      child: ElevatedButton(
                          style: buttonShape,
                          onPressed: () {
                            BlocProvider.of<HorizontalScrollBehaviorBloc>(
                                    context)
                                .add(ScrollRightEvent());
                          },
                          child: const Icon(FontAwesomeIcons.arrowRight))));
            }));
      },
    );
  }
}
