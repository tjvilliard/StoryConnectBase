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
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextButton.icon(
                            icon: Icon(Icons.create),
                            label: Text("Create"),
                            onPressed: () {},
                          )),
                    ),
                  ),
                  Flexible(
                      child: Align(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 800,
                          maxHeight: 40,
                          minHeight: 40,
                        ),
                        child: SearchBar(
                          leading: Icon(Icons.search),
                          hintText: "Search",
                        )),
                  )),
                  Flexible(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomAppBarMenu(context: context),
                  )),
                ]));
}
