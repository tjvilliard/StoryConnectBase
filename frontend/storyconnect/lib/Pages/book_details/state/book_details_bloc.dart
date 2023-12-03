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

class FetchBookChaptersEvent extends BookDetailsEvent {
  final int? bookId;
  const FetchBookChaptersEvent({required this.bookId});
}

class FetchBookTagsEvent extends BookDetailsEvent {
  final int? bookId;
  const FetchBookTagsEvent({required this.bookId});
}

class BookDetailsState {
  final Book? book;
  final GenreTags? bookTags;
  final LoadingStruct loadingBookStruct;
  final LoadingStruct loadingChaptersStruct;
  final String? uuid;
  final List<Chapter>? chapters;
  BookDetailsState({
    required this.book,
    required this.bookTags,
    required this.loadingBookStruct,
    required this.loadingChaptersStruct,
    required this.uuid,
    required this.chapters,
  });
}

typedef BookDetailsEmitter = Emitter<BookDetailsState>;

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  late final ReadingRepository _repo;

  BookDetailsBloc(this._repo)
      : super(BookDetailsState(
            book: null,
            bookTags: null,
            loadingBookStruct: const LoadingStruct(isLoading: false),
            loadingChaptersStruct: const LoadingStruct(isLoading: false),
            uuid: null,
            chapters: [])) {
    on<FetchBookDetailsEvent>((event, emit) => fetchBook(event, emit));
    on<FetchBookChaptersEvent>((event, emit) => fetchBookChapters(event, emit));
  }

  void fetchBookChapters(
      FetchBookChaptersEvent event, BookDetailsEmitter emit) async {
    emit(BookDetailsState(
      book: state.book,
      bookTags: state.bookTags,
      loadingBookStruct: const LoadingStruct(isLoading: true),
      loadingChaptersStruct: state.loadingChaptersStruct,
      uuid: state.uuid,
      chapters: state.chapters,
    ));

    List<Chapter> chapters = await _repo.getChapters(event.bookId!);
    chapters.sort((a, b) => a.id.compareTo(b.id));

    emit(BookDetailsState(
      book: state.book,
      bookTags: state.bookTags,
      loadingBookStruct: const LoadingStruct(isLoading: false),
      loadingChaptersStruct: state.loadingChaptersStruct,
      uuid: state.uuid,
      chapters: chapters,
    ));
  }

  void fetchBook(FetchBookDetailsEvent event, BookDetailsEmitter emit) async {
    emit(BookDetailsState(
      book: state.book,
      bookTags: state.bookTags,
      loadingBookStruct: state.loadingBookStruct,
      loadingChaptersStruct: const LoadingStruct(isLoading: true),
      uuid: state.uuid,
      chapters: state.chapters,
    ));

    Book? book = await _repo.getBook(event.bookId);
    GenreTags? tags = await _repo.getBookTags(event.bookId!);
    String? uuid = await _repo.getUUIDbyDisplayName(book!.authorName!);

    emit(BookDetailsState(
      book: book,
      bookTags: tags,
      loadingBookStruct: state.loadingBookStruct,
      loadingChaptersStruct: const LoadingStruct(isLoading: false),
      uuid: uuid,
      chapters: state.chapters,
    ));
  }
}
