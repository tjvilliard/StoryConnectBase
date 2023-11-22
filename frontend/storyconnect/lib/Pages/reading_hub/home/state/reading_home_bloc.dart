import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'reading_home_event.dart';
part 'reading_home_struct.dart';

typedef ReadingHomeEmitter = Emitter<ReadingHomeStruct>;

class ReadingHomeBloc extends Bloc<ReadingHomeEvent, ReadingHomeStruct> {
  late final ReadingRepository repository;
  ReadingHomeBloc(this.repository)
      : super(ReadingHomeStruct(
          allBooks: [],
          mappedBooks: {},
          loadingStruct: const LoadingStruct(isLoading: false),
        )) {
    on<GetBooksEvent>((event, emit) => fetchBooks(event, emit));
  }

  ///
  void fetchBooks(ReadingHomeEvent event, ReadingHomeEmitter emit) async {
    emit(ReadingHomeStruct(
      allBooks: state.allBooks,
      mappedBooks: {},
      loadingStruct: LoadingStruct.loading((event.isLoading)),
    ));

    List<Book> books = await repository.getBooks();

    print(books);

    emit(ReadingHomeStruct(
      allBooks: books,
      mappedBooks: {},
      loadingStruct: LoadingStruct.loading(false),
    ));
  }
}
