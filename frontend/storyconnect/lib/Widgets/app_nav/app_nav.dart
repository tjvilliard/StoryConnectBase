import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/app_nav/app_menu.dart';
import 'package:storyconnect/Widgets/app_nav/appbar_button.dart';

class CustomAppBar extends AppBar {
  final BuildContext context;

  static const double height = 56.0;

  CustomAppBar({super.key, required this.context})
      : super(
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
                  const Flexible(
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
                              // Flexible(
                              //     child: ConstrainedBox(
                              //   constraints: BoxConstraints(
                              //     maxWidth: 800,
                              //     minWidth: 100,
                              //     maxHeight: 40,
                              //     minHeight: 40,
                              //   ),
                              //   child: SearchBar(
                              //     leading:
                              //         Icon(FontAwesomeIcons.magnifyingGlass),
                              //     hintText: "Search",
                              //   ),
                              // )),
                              // Dropdown Menu Button.
                              Flexible(
                                child: CustomAppBarMenu(context: context),
                              ),
                            ],
                          ))),
                ]));
}
