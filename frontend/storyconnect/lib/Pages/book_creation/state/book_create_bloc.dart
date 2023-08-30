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
      emit(state.copyWith(
          serializer: state.serializer.copyWith(author: event.author)));
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

    on<SaveBookEvent>((event, emit) {
      saveBook(event, emit);
    });
  }

  Future<void> saveBook(SaveBookEvent event, BookCreateEmitter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.message("Saving Book")));

    // TODO: Add error handling (ie looking over the serializer and making sure it's valid)
    bool success = await repository.createBook(serializer: state.serializer);
    // bool success = false;

    if (success) {
      emit(state.copyWith(loadingStruct: LoadingStruct.loading(false)));
    } else {
      emit(state.copyWith(
          loadingStruct: LoadingStruct.errorMessage(
              "There was an error creating the book.")));
    }
  }
}
