import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Services/Authentication/sign_out_service.dart';
import 'package:storyconnect/Widgets/app_nav/appbar_button.dart';

class CustomAppBarMenu extends MenuAnchor {
  final BuildContext context;

  CustomAppBarMenu({Key? key, required this.context})
      : super(
            menuChildren: [
              AppBarMenuButton(
                  context: context,
                  onPressed: () {
                    SignOutService().signOut();
                    Beamer.of(context).beamToNamed("/");
                  },
                  child: Text("Sign Out"))
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
