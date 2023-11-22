import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/serializers/library_entry_serializer.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'reading_home_event.dart';
part 'reading_home_struct.dart';

typedef ReadingHomeEmitter = Emitter<ReadingHomeStruct>;

class ReadingHomeBloc extends Bloc<ReadingHomeEvent, ReadingHomeStruct> {
  late final ReadingRepository _repo;
  ReadingHomeBloc(this._repo)
      : super(ReadingHomeStruct(
          allBooks: [],
          libraryBooks: [],
          mappedBooks: {},
          loadingStruct: const LoadingStruct(isLoading: false),
        )) {
    on<FetchBooksEvent>((event, emit) => fetchBooks(event, emit));
    on<RemoveLibraryBookEvent>((event, emit) => removeBook(event, emit));
    on<AddLibraryBookEvent>((event, emit) => addBook(event, emit));
  }

  ///
  void fetchBooks(ReadingHomeEvent event, ReadingHomeEmitter emit) async {
    emit(ReadingHomeStruct(
      allBooks: state.allBooks,
      libraryBooks: state.libraryBooks,
      mappedBooks: {},
      loadingStruct: LoadingStruct.loading((event.isLoading)),
    ));

    List<Book> books = await _repo.getBooks();
    await _repo.getLibraryBooks();
    List<Book> libBooks = _repo.libraryBookMap.values.toList();

    emit(ReadingHomeStruct(
      allBooks: books,
      libraryBooks: libBooks,
      mappedBooks: {},
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  ///
  void removeBook(RemoveLibraryBookEvent event, ReadingHomeEmitter emit) async {
    emit(ReadingHomeStruct(
      allBooks: state.allBooks,
      mappedBooks: state.mappedBooks,
      libraryBooks: state.libraryBooks,
      loadingStruct: LoadingStruct.loading(true),
    ));

    MapEntry<Library, Book> entryToRemove = _repo.libraryBookMap.entries
        .where((entry) => entry.value.id == event.bookId)
        .first;

    await _repo.removeLibraryBook(LibraryEntrySerializer(
      id: entryToRemove.key.id,
      book: entryToRemove.value.id,
      status: entryToRemove.key.status,
    ));

    List<Book> libBooks = _repo.libraryBookMap.values.toList();

    emit(ReadingHomeStruct(
      allBooks: state.allBooks,
      mappedBooks: state.mappedBooks,
      libraryBooks: libBooks,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  ///
  void addBook(AddLibraryBookEvent event, ReadingHomeEmitter emit) async {
    emit(ReadingHomeStruct(
      allBooks: state.allBooks,
      mappedBooks: state.mappedBooks,
      libraryBooks: state.libraryBooks,
      loadingStruct: LoadingStruct.loading(true),
    ));

    await _repo.addLibraryBook(LibraryEntrySerializer(
      book: event.bookId,
      status: 1,
    ));

    List<Book> libBooks = _repo.libraryBookMap.values.toList();

    emit(ReadingHomeStruct(
      allBooks: state.allBooks,
      mappedBooks: state.mappedBooks,
      loadingStruct: LoadingStruct.loading(false),
      libraryBooks: libBooks,
    ));
  }
}
