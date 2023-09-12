import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';
import 'package:storyconnect/Pages/book_creation/serializers/book_creation_serializer.dart';

part 'book_create_bloc.freezed.dart';
part 'book_create_state.dart';
part 'book_create_events.dart';

typedef BookCreateEmitter = void Function(BookCreateState);

class BookCreateBloc extends Bloc<BookCreateEvent, BookCreateState> {
  final WritingRepository repository;
  BookCreateBloc(this.repository) : super(BookCreateState.initial()) {
    on<AuthorChangedEvent>((event, emit) {
      // emit(state.copyWith(
      //     serializer: state.serializer.copyWith(author: event.author)));
    });
    on<TitleChangedEvent>((event, emit) {
      emit(state.copyWith(
          serializer: state.serializer.copyWith(title: event.title)));
    });

    on<LanguageChangedEvent>((event, emit) {
      emit(state.copyWith(
          serializer: state.serializer.copyWith(language: event.language)));
    });

    on<TargetAudienceChangedEvent>((event, emit) {
      emit(state.copyWith(
          serializer:
              state.serializer.copyWith(targetAudience: event.targetAudience)));
    });

    on<SaveBookEvent>((event, emit) => saveBook(event, emit));

    on<ResetEvent>((event, emit) {
      emit(state.copyWith(
          createdBookId: null,
          serializer: BookCreationSerializer.initial(),
          loadingStruct: LoadingStruct.loading(false)));
    });
  }

  Future<void> saveBook(SaveBookEvent event, BookCreateEmitter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.message("Saving Book")));

    final verified = state.serializer.verify();

    // if verify fails, add a message to the loading struct and return
    if (!verified) {
      emit(state.copyWith(
          loadingStruct: LoadingStruct.errorMessage(
              "Please fill out all fields before saving.")));
      return;
    }

    final bookID = await repository.createBook(serializer: state.serializer);
    // bool success = false;

    if (bookID != null) {
      emit(state.copyWith(
          loadingStruct: LoadingStruct.loading(false), createdBookId: bookID));
    } else {
      emit(state.copyWith(
          loadingStruct: LoadingStruct.errorMessage(
              "There was an error creating the book.")));
    }
  }
}
