import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';
import 'package:storyconnect/Services/firebase_storage_helper.dart';
import 'package:storyconnect/Widgets/book_forms/serializers/book_form_serializer.dart';

part 'book_create_bloc.freezed.dart';
part 'book_create_state.dart';
part 'book_create_events.dart';

typedef BookCreateEmitter = void Function(BookCreateState);

class BookCreateBloc extends Bloc<BookCreateEvent, BookCreateState> {
  final WritingRepository repository;
  BookCreateBloc(this.repository) : super(BookCreateState.initial()) {
    on<TitleChangedEvent>((event, emit) {
      emit(state.copyWith(serializer: state.serializer.copyWith(title: event.title)));
    });

    on<LanguageChangedEvent>((event, emit) {
      emit(state.copyWith(serializer: state.serializer.copyWith(language: event.language)));
    });

    on<TargetAudienceChangedEvent>((event, emit) {
      emit(state.copyWith(serializer: state.serializer.copyWith(targetAudience: event.targetAudience)));
    });

    on<CopyrightChangedEvent>((event, emit) {
      emit(state.copyWith(serializer: state.serializer.copyWith(copyright: event.copyright)));
    });

    on<SynopsisChangedEvent>((event, emit) {
      emit(state.copyWith(serializer: state.serializer.copyWith(synopsis: event.Synopsis)));
    });

    on<SaveBookEvent>((event, emit) => saveBook(event, emit));
    on<UploadImageEvent>((event, emit) => uploadImage(event, emit));

    on<ResetEvent>((event, emit) {
      emit(state.copyWith(
          createdBookId: null, serializer: BookFormSerializer.initial(), loadingStruct: LoadingStruct.loading(false)));
    });
  }

  Future<void> uploadImage(UploadImageEvent event, BookCreateEmitter emit) async {
    FilePicker platformFilePicker = FilePicker.platform;
    FilePickerResult? result = await platformFilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    // convert the image to base 64
    if (result != null) {
      // get file from bytes since web doesn't support path

      emit(state.copyWith(imageTitle: result.files.single.name, imageFile: result.files.single.bytes));
    }
  }

  Future<void> saveBook(SaveBookEvent event, BookCreateEmitter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.message("Saving Book")));

    final verified = state.serializer.verify();

    // if verify fails, add a message to the loading struct and return
    if (!verified) {
      emit(state.copyWith(loadingStruct: LoadingStruct.errorMessage("Please fill out all fields before saving.")));
      return;
    }

    // if the image is not null, upload it
    if (state.imageFile != null) {
      emit(state.copyWith(
          serializer: state.serializer.copyWith(cover: await uploadImageDirectlyToFirebase(state.imageFile!))));
    }

    final bookID = await repository.createBook(serializer: state.serializer);
    // bool success = false;

    if (bookID != null) {
      emit(state.copyWith(loadingStruct: LoadingStruct.loading(false), createdBookId: bookID));
    } else {
      emit(state.copyWith(loadingStruct: LoadingStruct.errorMessage("There was an error creating the book.")));
    }
  }
}
