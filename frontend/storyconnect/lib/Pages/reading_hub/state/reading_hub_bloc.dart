import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/serializers/library_entry_serializer.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'reading_hub_event.dart';
part 'reading_hub_struct.dart';

typedef ReadingHubEmitter = Emitter<ReadingHubStruct>;

///
class ReadingHubBloc extends Bloc<ReadingHomeEvent, ReadingHubStruct> {
  ///
  late final ReadingRepository _repo;

  ///
  ReadingHubBloc(this._repo)
      : super(ReadingHubStruct(
          allBooks: [],
          libraryBookMap: {},
          mappedBooks: {},
          loadingStruct: const LoadingStruct(isLoading: false),
        )) {
    on<FetchBooksEvent>((event, emit) => fetchBooks(event, emit));
    on<RemoveLibraryBookEvent>((event, emit) => removeBook(event, emit));
    on<AddLibraryBookEvent>((event, emit) => addBook(event, emit));
  }

  ///
  void fetchBooks(ReadingHomeEvent event, ReadingHubEmitter emit) async {
    //
    emit(ReadingHubStruct(
      allBooks: state.allBooks,
      libraryBookMap: state.libraryBookMap,
      mappedBooks: {},
      loadingStruct: LoadingStruct.loading((event.isLoading)),
    ));

    //
    List<Book> books = await _repo.getBooks();
    Map<Library, Book> libBookMap = await _repo.getLibraryBooks();

    //
    emit(ReadingHubStruct(
      allBooks: books,
      libraryBookMap: libBookMap,
      mappedBooks: {},
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  ///
  void removeBook(RemoveLibraryBookEvent event, ReadingHubEmitter emit) async {
    //
    emit(ReadingHubStruct(
      allBooks: state.allBooks,
      libraryBookMap: state.libraryBookMap,
      mappedBooks: state.mappedBooks,
      loadingStruct: LoadingStruct.loading(true),
    ));

    //
    MapEntry<Library, Book> entryToRemove = state.libraryBookMap.entries
        .where((entry) => entry.value.id == event.bookId)
        .first;

    //
    await _repo.removeLibraryBook(LibraryEntrySerializer(
      id: entryToRemove.key.id,
      book: entryToRemove.value.id,
      status: entryToRemove.key.status,
    ));

    //
    Map<Library, Book> libBookMap = await _repo.getLibraryBooks();

    // Emit the new home state.
    emit(ReadingHubStruct(
      allBooks: state.allBooks,
      libraryBookMap: libBookMap,
      mappedBooks: state.mappedBooks,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  ///
  void addBook(AddLibraryBookEvent event, ReadingHubEmitter emit) async {
    //
    emit(ReadingHubStruct(
      allBooks: state.allBooks,
      libraryBookMap: state.libraryBookMap,
      mappedBooks: state.mappedBooks,
      loadingStruct: LoadingStruct.loading(true),
    ));

    //
    await _repo.addLibraryBook(LibraryEntrySerializer(
      book: event.bookId,
      status: 1,
    ));

    //
    Map<Library, Book> libBookMap = await _repo.getLibraryBooks();

    //
    emit(ReadingHubStruct(
      allBooks: state.allBooks,
      libraryBookMap: libBookMap,
      mappedBooks: state.mappedBooks,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }
}
