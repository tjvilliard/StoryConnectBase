import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/serializers/library_entry_serializer.dart';
import 'package:storyconnect/Repositories/library_repository.dart';

part 'library_event.dart';
part 'library_struct.dart';

typedef LibraryEmitter = Emitter<LibraryStruct>;

class LibraryBloc extends Bloc<LibraryEvent, LibraryStruct> {
  /// The Book Reading Repository.
  late final LibraryRepository _repo;

  LibraryBloc(this._repo)
      : super(LibraryStruct(
          libraryBooks: [],
          loadingStruct: LoadingStruct(isLoading: false),
        )) {
    on<GetLibraryEvent>((event, emit) => fetchBooks(event, emit));
    on<RemoveBookEvent>((event, emit) => removeBook(event, emit));
    on<AddBookEvent>((event, emit) => addBook(event, emit));
  }

  ///
  void fetchBooks(GetLibraryEvent event, LibraryEmitter emit) async {
    emit(LibraryStruct(
      libraryBooks: state.libraryBooks,
      loadingStruct: LoadingStruct.loading((event.isLoading)),
    ));

    await this._repo.getLibraryBooks();

    List<Book> libBooks = this._repo.libraryBookMap.values.toList();

    emit(LibraryStruct(
      libraryBooks: libBooks,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  ///
  void removeBook(RemoveBookEvent event, LibraryEmitter emit) async {
    emit(LibraryStruct(
      libraryBooks: state.libraryBooks,
      loadingStruct: LoadingStruct.loading(true),
    ));

    ///
    MapEntry<Library, Book> entryToRemove = this
        ._repo
        .libraryBookMap
        .entries
        .where((entry) => entry.value.id == event.bookId)
        .first;

    await this._repo.removeLibraryBook(LibraryEntrySerializer(
          id: entryToRemove.key.id,
          book: entryToRemove.value.id,
          status: entryToRemove.key.status,
        ));

    List<Book> libBooks = this._repo.libraryBookMap.values.toList();

    emit(LibraryStruct(
      libraryBooks: libBooks,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  void addBook(AddBookEvent event, Emitter<LibraryStruct> emit) async {
    emit(LibraryStruct(
      libraryBooks: state.libraryBooks,
      loadingStruct: LoadingStruct.loading(true),
    ));

    await this._repo.addLibraryBook(LibraryEntrySerializer(
          book: event.bookId,
          status: 1,
        ));

    List<Book> libBooks = this._repo.libraryBookMap.values.toList();

    emit(LibraryStruct(
      loadingStruct: LoadingStruct.loading(false),
      libraryBooks: libBooks,
    ));
  }
}
