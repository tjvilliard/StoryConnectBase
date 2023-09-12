import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomScaffold extends Scaffold {
  final VoidCallback? navigateBackFunction;

  CustomScaffold(
      {super.body,
      super.appBar,
      super.floatingActionButton,
      super.floatingActionButtonLocation,
      super.floatingActionButtonAnimator,
      super.persistentFooterButtons,
      super.drawer,
      super.onDrawerChanged,
      super.endDrawer,
      super.onEndDrawerChanged,
      super.bottomNavigationBar,
      super.bottomSheet,
      super.backgroundColor,
      super.resizeToAvoidBottomInset,
      super.primary,
      super.drawerDragStartBehavior,
      super.extendBody,
      super.extendBodyBehindAppBar,
      super.drawerScrimColor,
      super.drawerEdgeDragWidth,
      super.drawerEnableOpenDragGesture,
      super.endDrawerEnableOpenDragGesture,
      super.restorationId,
      this.navigateBackFunction});

  // if back nav is enabled, then the back button will be shown
  @override
  Widget get body {
    if (navigateBackFunction != null) {
      return Stack(
        children: [
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            bottom: 0,
            child: super.body!,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: navigateBackFunction!,
            ),
          ),

          // position the body slighly below the back button
        ],
      );
    } else {
      return super.body!;
    }
  }
}
