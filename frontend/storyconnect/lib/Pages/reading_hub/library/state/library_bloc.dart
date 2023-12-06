import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/serializers/library_entry_serializer.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'library_event.dart';
part 'library_state.dart';
part 'library_bloc.freezed.dart';

typedef LibraryEmitter = Emitter<LibraryState>;

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  late final ReadingRepository _repo;

  LibraryBloc(this._repo) : super(LibraryState.initial()) {
    on<FetchLibraryBooksEvent>((event, emit) => fetchLibraryBooks(event, emit));
    on<AddBookToLibraryEvent>((event, emit) => addBookToLibrary(event, emit));
    on<RemoveBookFromLibraryEvent>(
        (event, emit) => removeBookFromLibrary(event, emit));
    on<SetLibraryBookToReadingEvent>(
        (event, emit) => updateLibraryBookStatus(event, emit));
    on<SetLibraryBookToCompletedEvent>(
        (event, emit) => updateLibraryBookStatus(event, emit));
    on<SetLibraryBookToUnreadEvent>(
        (event, emit) => updateLibraryBookStatus(event, emit));
  }

  /// Fetches the current list of the user's library books.
  void fetchLibraryBooks(
      FetchLibraryBooksEvent event, LibraryEmitter emit) async {
    emit(state.copyWith(
      libraryLoadingStruct: LoadingStruct.loading(true),
    ));

    Map<Library, Book> libBookMap = await _repo.getLibraryBooks();

    emit(state.copyWith(
        libraryLoadingStruct: LoadingStruct.loading(false),
        libraryBookMap: libBookMap));
  }

  /// Adds a new entry to the user's current list of library books.
  void addBookToLibrary(
      AddBookToLibraryEvent event, LibraryEmitter emit) async {
    emit(state.copyWith(
      libraryLoadingStruct: LoadingStruct.loading(true),
    ));

    await _repo.addLibraryBook(
      LibraryEntrySerializer(book: event.bookId, status: 3),
    );

    Map<Library, Book> updatedLibBookMap = await _repo.getLibraryBooks();

    emit(state.copyWith(
      libraryLoadingStruct: LoadingStruct.loading(false),
      libraryBookMap: updatedLibBookMap,
    ));
  }

  /// Removes an existing entry from the user's current list of library books.
  void removeBookFromLibrary(
      RemoveBookFromLibraryEvent event, LibraryEmitter emit) async {
    emit(state.copyWith(
      libraryLoadingStruct: LoadingStruct.loading(true),
    ));

    MapEntry<Library, Book> entryToRemove = state.getLibraryEntry(event.bookId);

    await _repo.removeLibraryBook(LibraryEntrySerializer(
      id: entryToRemove.key.id,
      book: entryToRemove.value.id,
      status: entryToRemove.key.status,
    ));

    Map<Library, Book> updatedLibBookMap = await _repo.getLibraryBooks();

    emit(state.copyWith(
      libraryLoadingStruct: LoadingStruct.loading(false),
      libraryBookMap: updatedLibBookMap,
    ));
  }

  /// Updates the state of an existing entry from the user's current list of library books.
  void updateLibraryBookStatus(
      UpdateLibraryBookStatusEvent event, LibraryEmitter emit) async {
    emit(state.copyWith(
      libraryLoadingStruct: LoadingStruct.loading(true),
    ));

    Library libraryEntry = state.getLibrary(event.bookId);
    libraryEntry = libraryEntry.copyWith(
      status: event.newStatus,
      book: event.bookId,
    );

    await _repo.changeLibraryBookStatus(libraryEntry);

    Map<Library, Book> updatedLibBookMap = await _repo.getLibraryBooks();

    emit(state.copyWith(
      libraryLoadingStruct: LoadingStruct.loading(false),
      libraryBookMap: updatedLibBookMap,
    ));
  }
}
