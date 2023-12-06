import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/genre_tagging/genre.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'book_details_state.dart';
part 'book_details_bloc.freezed.dart';

abstract class BookDetailsEvent {
  const BookDetailsEvent();
}

class LoadBookDetailsEvent extends BookDetailsEvent {
  final int? bookId;
  const LoadBookDetailsEvent({required this.bookId});
}

class LoadBookChaptersEvent extends BookDetailsEvent {
  final int? bookId;
  const LoadBookChaptersEvent({required this.bookId});
}

typedef BookDetailsEmitter = Emitter<BookDetailsState>;

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  late final ReadingRepository _repo;

  BookDetailsBloc(this._repo) : super(BookDetailsState.initial()) {
    on<LoadBookDetailsEvent>((event, emit) => loadBookDetails(event, emit));
    on<LoadBookChaptersEvent>((event, emit) => loadBookChapters(event, emit));
  }

  void loadBookChapters(
      LoadBookChaptersEvent event, BookDetailsEmitter emit) async {
    emit(state.copyWith(
      chapterLoadingStruct: LoadingStruct.loading(true),
    ));

    List<Chapter> chapters = await _repo.getChapters(event.bookId!);

    emit(state.copyWith(
      chapters: chapters,
      chapterLoadingStruct: LoadingStruct.loading(false),
    ));
  }

  void loadBookDetails(
      LoadBookDetailsEvent event, BookDetailsEmitter emit) async {
    emit(state.copyWith(
      bookDetailsLoadingStruct: LoadingStruct.loading(true),
    ));

    Book? book = await _repo.getBook(event.bookId);
    print("Book: ${book == null}");

    GenreTags? tags = await _repo.getBookTags(event.bookId!);
    print("Tags: ${tags == null}");

    String? uuid = await _repo.getUUIDbyDisplayName(book!.authorName!);
    print(uuid == null);

    emit(state.copyWith(
        book: book,
        bookTags: tags ?? state.bookTags,
        uuid: uuid ?? state.uuid,
        bookDetailsLoadingStruct: LoadingStruct.loading(false)));
  }
}
