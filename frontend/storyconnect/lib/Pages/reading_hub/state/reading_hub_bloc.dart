import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/serializers/library_entry_serializer.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'reading_hub_event.dart';
part 'reading_hub_struct.dart';

typedef ReadingHubEmitter = Emitter<ReadingHubStruct>;

class ReadingHubBloc extends Bloc<ReadingHomeEvent, ReadingHubStruct> {
  late final ReadingRepository _repo;

  ReadingHubBloc(this._repo)
      : super(ReadingHubStruct(
          recommendedBooks: [],
          libraryBookMap: {},
          loadingStruct: const LoadingStruct(isLoading: false),
        )) {
    on<FetchBooksEvent>((event, emit) => fetchBooks(event, emit));

    on<FetchLibraryBooksEvent>((event, emit) => fetchLibraryBooks(event, emit));
    on<RemoveLibraryBookEvent>((event, emit) => removeLibraryBook(event, emit));
    on<AddLibraryBookEvent>((event, emit) => addLibraryBook(event, emit));
    on<UpdateLibraryBookStatusEvent>(
        (event, emit) => updateLibraryBookStatus(event, emit));
  }

  void fetchBooks(ReadingHomeEvent event, ReadingHubEmitter emit) async {
    emit(ReadingHubStruct(
      recommendedBooks: state.recommendedBooks,
      libraryBookMap: state.libraryBookMap,
      loadingStruct: LoadingStruct.loading((event.isLoading)),
    ));

    List<Book> books = await _repo.getBooks();
    Map<Library, Book> libBookMap = await _repo.getLibraryBooks();

    emit(ReadingHubStruct(
      recommendedBooks: books,
      libraryBookMap: libBookMap,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  void fetchLibraryBooks(ReadingHomeEvent event, ReadingHubEmitter emit) async {
    emit(ReadingHubStruct(
      recommendedBooks: state.recommendedBooks,
      libraryBookMap: state.libraryBookMap,
      loadingStruct: LoadingStruct.loading((event.isLoading)),
    ));

    Map<Library, Book> libBookMap = await _repo.getLibraryBooks();

    emit(ReadingHubStruct(
      recommendedBooks: state.recommendedBooks,
      libraryBookMap: libBookMap,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  void fetchReccomendedBooks(
      ReadingHomeEvent event, ReadingHubEmitter emit) async {}

  void removeLibraryBook(
      RemoveLibraryBookEvent event, ReadingHubEmitter emit) async {
    emit(ReadingHubStruct(
      recommendedBooks: state.recommendedBooks,
      libraryBookMap: state.libraryBookMap,
      loadingStruct: LoadingStruct.loading(true),
    ));

    MapEntry<Library, Book> entryToRemove = state.libraryBookMap.entries
        .where((entry) => entry.value.id == event.bookId)
        .first;

    await _repo.removeLibraryBook(LibraryEntrySerializer(
      id: entryToRemove.key.id,
      book: entryToRemove.value.id,
      status: entryToRemove.key.status,
    ));

    Map<Library, Book> libBookMap = await _repo.getLibraryBooks();

    emit(ReadingHubStruct(
      recommendedBooks: state.recommendedBooks,
      libraryBookMap: libBookMap,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  void addLibraryBook(AddLibraryBookEvent event, ReadingHubEmitter emit) async {
    emit(ReadingHubStruct(
      recommendedBooks: state.recommendedBooks,
      libraryBookMap: state.libraryBookMap,
      loadingStruct: LoadingStruct.loading(true),
    ));

    await _repo.addLibraryBook(LibraryEntrySerializer(
      book: event.bookId,
      status: 3,
    ));

    Map<Library, Book> libBookMap = await _repo.getLibraryBooks();

    emit(ReadingHubStruct(
      recommendedBooks: state.recommendedBooks,
      libraryBookMap: libBookMap,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  void updateLibraryBookStatus(
      UpdateLibraryBookStatusEvent event, ReadingHubEmitter emit) async {
    print("[INFO] setting state loading");

    emit(ReadingHubStruct(
      recommendedBooks: state.recommendedBooks,
      libraryBookMap: state.libraryBookMap,
      loadingStruct: LoadingStruct.loading(true),
    ));

    print("[INFO] getting library item with id.");

    MapEntry<Library, Book> libBookMapItem = state.libraryBookMap.entries
        .where((entry) => entry.value.id == event.bookId)
        .first;

    Library lib = libBookMapItem.key;

    print("[DEBUG]: init lib item status $lib");

    lib = lib.copyWith(book: libBookMapItem.value.id, status: event.status);

    print("[DEBUG]: updated lib item status $lib");

    _repo.changeLibraryBookStatus(lib);

    Map<Library, Book> libBookMap = await _repo.getLibraryBooks();

    emit(ReadingHubStruct(
      recommendedBooks: state.recommendedBooks,
      libraryBookMap: libBookMap,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }
}
