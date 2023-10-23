import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

abstract class ReadingHomeEvent {
  bool isLoading;
  ReadingHomeEvent({required this.isLoading});
}

class GetBooksEvent extends ReadingHomeEvent {
  GetBooksEvent() : super(isLoading: true);
}

class InitialLoadEvent extends ReadingHomeEvent {
  InitialLoadEvent() : super(isLoading: true);
}

/// Represents the state of the reader's home page
/// for now, simply includes the complete list of books in
/// the database to read. Should later be refined to not get
/// the whole list of books.
class ReadingHomeStruct {
  // add categories of books to navigate and
  // request based on user's interest.
  /*
  * Map of categories to books

  */

  final List<Book> books;
  final List<Book> libraryBooks;
  final Book? bookToNavigate;
  final LoadingStruct loadingStruct;

  ReadingHomeStruct({
    required this.books,
    required this.libraryBooks,
    required this.loadingStruct,
    this.bookToNavigate,
  });
}

typedef ReadingHomeEmitter = Emitter<ReadingHomeStruct>;

class ReadingHomeBloc extends Bloc<ReadingHomeEvent, ReadingHomeStruct> {
  late final ReadingRepository repository;
  ReadingHomeBloc(this.repository)
      : super(ReadingHomeStruct(
          books: [],
          libraryBooks: [],
          loadingStruct: LoadingStruct(isLoading: false),
        )) {
    on<GetBooksEvent>((event, emit) => updateBooksList(event, emit));
  }

  void updateBooksList(ReadingHomeEvent event, ReadingHomeEmitter emit) async {
    emit(ReadingHomeStruct(
      books: state.books,
      libraryBooks: state.libraryBooks,
      loadingStruct: LoadingStruct.loading((event.isLoading)),
    ));
    List<Book> books = await this.repository.getBooks();
    List<Book> libBooks = await this.repository.getLibraryBooks();

    emit(ReadingHomeStruct(
      books: books,
      libraryBooks: libBooks,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }
}
