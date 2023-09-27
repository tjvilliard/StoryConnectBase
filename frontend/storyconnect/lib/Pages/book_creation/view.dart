import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/book_creation/components/book_creation_form_fields.dart';
import 'package:storyconnect/Pages/book_creation/components/save_book_button.dart';
import 'package:storyconnect/Pages/book_creation/state/book_create_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/body.dart';
import 'package:storyconnect/Widgets/custom_scaffold.dart';
import 'package:storyconnect/Widgets/header.dart';

class WritingCreationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<BookCreateBloc, BookCreateState>(
        listener: (context, state) {
          if (state.createdBookId != null) {
            Beamer.of(context)
                .beamToReplacementNamed(PageUrls.book(state.createdBookId!));
          }
        },
        child: CustomScaffold(
            appBar: AppBar(),
            navigateBackFunction: () {
              final beamed = Beamer.of(context).beamBack();
              if (!beamed) {
                Beamer.of(context).beamToNamed(PageUrls.writerHome);
              }
            },
            body: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Header(
                  title: "Create a Book",
                  subtitle: "Let's get started!",
                  alignment: WrapAlignment.center,
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
            ))));
  }
}
