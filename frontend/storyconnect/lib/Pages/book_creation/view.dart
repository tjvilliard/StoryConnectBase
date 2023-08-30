import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/book_creation/components/book_creation_form_fields.dart';
import 'package:storyconnect/Pages/book_creation/components/save_book_button.dart';
import 'package:storyconnect/Widgets/body.dart';
import 'package:storyconnect/Widgets/custom_scaffold.dart';
import 'package:storyconnect/Widgets/header.dart';

class WritingCreationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        // TODO: Make a navigation app bar
        appBar: AppBar(),
        navigateBackFunction: () {
          Beamer.of(context).beamBack();
        },
        body: ListView(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Header(
                title: "Create A Book",
                subtitle: "Let's get started!",
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              Body(
                  child: Card(
                      surfaceTintColor: Colors.white,
                      elevation: 4,
                      child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              BookCreationFormFields(),
                              SaveBookButton()
                            ],
                          )))),
            ],
          )
        ]));
  }
}
