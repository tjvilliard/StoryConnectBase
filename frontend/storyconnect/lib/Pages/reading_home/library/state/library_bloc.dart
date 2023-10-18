import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'library_event.dart';
part 'library_struct.dart';

typedef LibraryEmitter = Emitter<LibraryStruct>;

class LibraryBloc extends Bloc<LibraryEvent, LibraryStruct> {
  /// The Book Reading Repository.
  late final ReadingRepository _repo;

  LibraryBloc(this._repo) : super(LibraryStruct(libraryBooks: [])) {
    on<GetLibraryEvent>((event, emit) => getLibrary(event, emit));
  }

  getLibrary(GetLibraryEvent event, LibraryEmitter emit) async {
    emit(LibraryStruct(libraryBooks: state.libraryBooks));
    List<Book> libBooks = await this._repo.getBooks();
  }
}
