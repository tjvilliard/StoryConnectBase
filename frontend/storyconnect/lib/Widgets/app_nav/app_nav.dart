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
          shape: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1.5)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Center(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 800,
                            maxHeight: 40,
                            minHeight: 40,
                          ),
                          child: SearchBar(
                            leading: Icon(Icons.search),
                            hintText: "Search",
                          )))),
              CustomAppBarMenu(context: context)
            ],
          ),
          surfaceTintColor: Colors.white70,
          centerTitle: false,
          elevation: 5,
          toolbarHeight: CustomAppBar.height,
        );
}
