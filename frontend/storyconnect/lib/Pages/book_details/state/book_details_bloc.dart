import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/genre_tagging/genre.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

abstract class BookDetailsEvent {
  const BookDetailsEvent();
}

class FetchBookDetailsEvent extends BookDetailsEvent {
  final int? bookId;
  const FetchBookDetailsEvent({required this.bookId});
}

class BookDetailsState {
  final Book? book;
  final GenreTags? bookTags;
  final LoadingStruct loadingStruct;
  BookDetailsState({
    required this.book,
    required this.bookTags,
    required this.loadingStruct,
  });
}

typedef BookDetailsEmitter = Emitter<BookDetailsState>;

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  late final ReadingRepository _repo;

  BookDetailsBloc(this._repo)
      : super(BookDetailsState(
          book: null,
          bookTags: null,
          loadingStruct: const LoadingStruct(isLoading: false),
        )) {
    on<FetchBookDetailsEvent>((event, emit) => fetchBook(event, emit));
  }

  void fetchBook(FetchBookDetailsEvent event, BookDetailsEmitter emit) async {
    if (kDebugMode) {
      print(event.bookId);
    }
    emit(BookDetailsState(
      book: state.book,
      bookTags: state.bookTags,
      loadingStruct: const LoadingStruct(isLoading: true),
    ));

    Book? book = await _repo.getBook(event.bookId);
    GenreTags? tags = await _repo.getBookTags(event.bookId!);
    emit(BookDetailsState(
      book: book,
      bookTags: tags,
      loadingStruct: const LoadingStruct(isLoading: false),
    ));
  }
}
