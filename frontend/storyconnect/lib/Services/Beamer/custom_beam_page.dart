import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomBeamPage extends BeamPage {
  static const _navType = BeamPageType.fadeTransition;

  const CustomBeamPage(
      {super.key,
      required super.child,
      super.title,
      super.onPopPage,
      super.popToNamed,
      super.routeBuilder,
      super.fullScreenDialog = false,
      super.opaque = true})
      : super(type: _navType);
}
