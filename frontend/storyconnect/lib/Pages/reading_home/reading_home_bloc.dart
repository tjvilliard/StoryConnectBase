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
  * List of books in library.
  */

  final List<Book> books;
  final Map<String, List<Book>> taggedBooks;
  final Book? bookToNavigate;
  final LoadingStruct loadingStruct;

  ReadingHomeStruct({
    required this.books,
    required this.loadingStruct,
    this.bookToNavigate,
    required this.taggedBooks,
  });
}

typedef ReadingHomeEmitter = Emitter<ReadingHomeStruct>;

class ReadingHomeBloc extends Bloc<ReadingHomeEvent, ReadingHomeStruct> {
  late final ReadingRepository repository;
  ReadingHomeBloc(this.repository)
      : super(ReadingHomeStruct(
          books: [],
          taggedBooks: {},
          loadingStruct: LoadingStruct(isLoading: false),
        )) {
    on<GetBooksEvent>((event, emit) => updateBooksList(event, emit));
  }

  void updateBooksList(ReadingHomeEvent event, ReadingHomeEmitter emit) async {
    emit(ReadingHomeStruct(
      books: state.books,
      taggedBooks: state.taggedBooks,
      loadingStruct: LoadingStruct.loading((event.isLoading)),
    ));
    List<Book> books = await this.repository.getBooks();
    Map<String, List<Book>> taggedBooks =
        await this.repository.getTaggedBooks();
    emit(ReadingHomeStruct(
      books: books,
      taggedBooks: taggedBooks,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }
}
