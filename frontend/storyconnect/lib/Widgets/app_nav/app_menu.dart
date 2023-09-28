import 'package:flutter/material.dart';
import 'package:storyconnect/Widgets/app_nav/appbar_button.dart';

class CustomAppBarMenu extends MenuAnchor {
  final BuildContext context;

  CustomAppBarMenu({Key? key, required this.context})
      : super(
            menuChildren: [
              MenuItemButton(
                onPressed: () {},
                child: Text("Item 1"),
              ),
              MenuItemButton(
                onPressed: () {},
                child: Text("Item 2"),
              ),
              MenuItemButton(
                onPressed: () {},
                child: Text("Item 3"),
              ),
            ],
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return AppBarIconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  });
            });
}
