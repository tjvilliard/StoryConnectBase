import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/app_nav/app_menu.dart';
import 'package:storyconnect/Widgets/app_nav/appbar_button.dart';
import 'package:storyconnect/Widgets/custom_search_bar.dart';

class CustomAppBar extends AppBar {
  final BuildContext context;

  static const double height = 56.0;

  CustomAppBar({Key? key, required this.context})
      : super(
            key: key,
            surfaceTintColor: Colors.white70,
            centerTitle: true,
            elevation: 5,
            toolbarHeight: CustomAppBar.height,
            shape: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1.5)),

            // The Leftmost set of Appbar widgets

            // The Central set of AppBar widgets
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            // Reading Hub Button
                            AppBarTextButton(
                              text: "Reading Hub",
                              icon: Icon(Icons.chrome_reader_mode_outlined),
                              uri: PageUrls.readerHome,
                            ),

                            // My Library Button
                            AppBarTextButton(
                              text: "My Library",
                              icon: Icon(FontAwesomeIcons.bookmark),
                              uri: PageUrls.readerLibrary,
                            ),

                            // Writing Hub Button
                            AppBarTextButton(
                              text: "Writing Hub",
                              icon: Icon(FontAwesomeIcons.pencil),
                              uri: PageUrls.writerHome,
                            ),
                          ]))),
                  Flexible(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Search Bar Placeholder
                              CustomSearchBar(),

                              // Dropdown Menu Button.
                              Flexible(
                                child: CustomAppBarMenu(context: context),
                              ),
                            ],
                          ))),
                ]));
}
