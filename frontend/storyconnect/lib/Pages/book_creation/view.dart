import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';

import 'package:storyconnect/Pages/book_creation/state/book_create_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/body.dart';
import 'package:storyconnect/Widgets/book_forms/book_form_fields.dart';
import 'package:storyconnect/Widgets/book_forms/save_book_button.dart';
import 'package:storyconnect/Widgets/custom_scaffold.dart';
import 'package:storyconnect/Widgets/header.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class WritingCreationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookCreateBloc, BookCreateState>(
        listener: (context, state) {
          if (state.createdBookId != null) {
            Beamer.of(context).beamToReplacementNamed(PageUrls.book(state.createdBookId!));
          }
        },
        builder: (context, state) => CustomScaffold(
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
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Card(
                        surfaceTintColor: Colors.white,
                        elevation: 4,
                        child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BookFormFields(
                                      defaults: BookFormFieldDefaults(
                                        title: state.serializer.title,
                                        synopsis: state.serializer.synopsis,
                                        language: languageConstantFromString(state.serializer.language),
                                        targetAudience: targetAudienceFromIndex(state.serializer.targetAudience),
                                      ),
                                      callbacks: BookFormFieldCallbacks(
                                        onCopyRightChanged: (option) {
                                          context
                                              .read<BookCreateBloc>()
                                              .add(CopyrightChangedEvent(copyrightOption: option));
                                        },
                                        onLanguageChanged: (language) {
                                          context
                                              .read<BookCreateBloc>()
                                              .add(LanguageChangedEvent(language: language.label));
                                        },
                                        onTargetAudienceChanged: (audience) {
                                          context
                                              .read<BookCreateBloc>()
                                              .add(TargetAudienceChangedEvent(targetAudience: audience));
                                        },
                                        onTitleChanged: (title) {
                                          context.read<BookCreateBloc>().add(TitleChangedEvent(title: title));
                                        },
                                        onSynopsisChanged: (synopsis) {
                                          context.read<BookCreateBloc>().add(SynopsisChangedEvent(Synopsis: synopsis));
                                        },
                                        onImageChanged: () {
                                          context.read<BookCreateBloc>().add(UploadImageEvent());
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  if (state.loadingStruct.isLoading) LoadingWidget(loadingStruct: state.loadingStruct),
                                  if (state.loadingStruct.message != null && state.loadingStruct.isLoading == false)
                                    Padding(padding: EdgeInsets.all(10), child: Text(state.loadingStruct.message!)),
                                  if (state.loadingStruct.isLoading == false)
                                    SaveBookButton(
                                      text: "Create Book",
                                      onPressed: () {
                                        context.read<BookCreateBloc>().add(SaveBookEvent());
                                      },
                                    )
                                ])
                              ],
                            )))),
              ],
            ))));
  }
}
