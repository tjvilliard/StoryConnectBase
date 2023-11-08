import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/library_repository.dart';

part 'library_event.dart';
part 'library_struct.dart';

/// Different Status Types of a library book.
enum LibraryBookStatus {
  Reading("Reading"),
  Completed("Completed"),
  ToBeRead("To Be Read");

  const LibraryBookStatus(this.description);
  final String description;
}

typedef LibraryEmitter = Emitter<LibraryStruct>;

class LibraryBloc extends Bloc<LibraryEvent, LibraryStruct> {
  /// The Book Reading Repository.
  late final LibraryRepository _repo;

  LibraryBloc(this._repo)
      : super(LibraryStruct(
          libraryBooks: [],
          loadingStruct: LoadingStruct(isLoading: false),
        )) {
    on<GetLibraryEvent>((event, emit) => getLibrary(event, emit));
    on<RemoveBookEvent>((event, emit) => removeBook(event, emit));
    on<AddBookEvent>((event, emit) => addBook(event, emit));
  }

  void getLibrary(GetLibraryEvent event, LibraryEmitter emit) async {
    this._repo.getLibraryBooks();

    emit(LibraryStruct(
      libraryBooks: this._repo.libraryBookMap.values.toList(),
      loadingStruct: LoadingStruct.loading((event.isLoading)),
    ));
  }

  void removeBook(RemoveBookEvent event, LibraryEmitter emit) async {}

  void addBook(AddBookEvent event, Emitter<LibraryStruct> emit) async {}
}
