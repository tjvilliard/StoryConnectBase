import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/browsing/components/content_panel/panel_item.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'library_event.dart';
part 'library_struct.dart';

typedef LibraryEmitter = Emitter<LibraryStruct>;

class LibraryBloc extends Bloc<LibraryEvent, LibraryStruct> {
  /// The Book Reading Repository.
  late final ReadingRepository _repo;

  LibraryBloc(this._repo)
      : super(LibraryStruct(
          libraryBooks: [],
          loadingStruct: LoadingStruct(isLoading: false),
        )) {
    on<GetLibraryEvent>((event, emit) => getLibrary(event, emit));
  }

  getLibrary(GetLibraryEvent event, LibraryEmitter emit) async {
    emit(LibraryStruct(
      libraryBooks: state.libraryBooks,
      loadingStruct: LoadingStruct.loading(true),
    ));
    List<Book> libBooks = await this._repo.getBooks();

    emit(LibraryStruct(
      libraryBooks: libBooks,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  removeBook(RemoveBookEvent event, LibraryEmitter emit) async {
    emit(LibraryStruct(
      libraryBooks: state.libraryBooks,
      loadingStruct: LoadingStruct.loading(true),
    ));

    event.bookId;

    //add book by book ID to library.
    List<Book> libBooks = await this._repo.getBooks();
    emit(LibraryStruct(
      libraryBooks: libBooks,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  addBook(AddBookEvent event, LibraryEmitter emit) async {
    emit(LibraryStruct(
      libraryBooks: state.libraryBooks,
      loadingStruct: LoadingStruct.loading(true),
    ));

    event.bookId;

    //add book by book ID to library.
    List<Book> libBooks = await this._repo.getBooks();
    emit(LibraryStruct(
      libraryBooks: libBooks,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }
}
