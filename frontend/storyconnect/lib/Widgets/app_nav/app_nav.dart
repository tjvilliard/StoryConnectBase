import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/app_nav/app_menu.dart';
import 'package:storyconnect/Widgets/app_nav/appbar_button.dart';

class CustomAppBar extends AppBar {
  final BuildContext context;

  static const double height = 56.0;

  CustomAppBar({Key? key, required this.context})
      : super(
            key: key,
            title: Text("StoryConnect"),
            centerTitle: true,
            elevation: 5,
            toolbarHeight: CustomAppBar.height,
            actions: [
              AppBarTextButton(
                  text: "Writing",
                  onPressed: () {
                    Beamer.of(context).beamToNamed(PageUrls.writerHome);
                  }),
              AppBarTextButton(
                  text: "Reading",
                  onPressed: () {
                    Beamer.of(context).beamToNamed(PageUrls.readerHome);
                  }),
              CustomAppBarMenu(context: context)
            ]);
}
