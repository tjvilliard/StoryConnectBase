import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_home/writing_repository.dart';

abstract class WritingHomeEvent {
  bool isLoading;
  WritingHomeEvent({required this.isLoading});
}

class GetBooksEvent extends WritingHomeEvent {
  GetBooksEvent() : super(isLoading: true);
}

class CreateBookEvent extends WritingHomeEvent {
  String title;
  CreateBookEvent({required this.title}) : super(isLoading: true);
}

class OpenBookEvent extends WritingHomeEvent {
  Book book;
  OpenBookEvent({required this.book}) : super(isLoading: true);
}

class WritingHomeStruct {
  final List<Book> books;
  final Book? bookToNavigate;
  final LoadingStruct loadingStruct;
  WritingHomeStruct(
      {required this.books, required this.loadingStruct, this.bookToNavigate});
}

typedef WritingHomeEmitter = Emitter<WritingHomeStruct>;

class WritingHomeBloc extends Bloc<WritingHomeEvent, WritingHomeStruct> {
  late final WritingRepository repository;
  WritingHomeBloc(this.repository)
      : super(WritingHomeStruct(
            books: [], loadingStruct: LoadingStruct(isLoading: false))) {
    on<GetBooksEvent>((event, emit) => updateBooks(event, emit));
    on<CreateBookEvent>((event, emit) => createBook(event, emit));
    on<OpenBookEvent>((event, emit) => openBook(event, emit));
  }

  void updateBooks(WritingHomeEvent event, WritingHomeEmitter emit) async {
    emit(WritingHomeStruct(
        books: state.books,
        loadingStruct: LoadingStruct.loading(event.isLoading)));
    List<Book> books = await repository.getBooks();
    emit(WritingHomeStruct(
        books: books, loadingStruct: LoadingStruct.loading(false)));
  }

  void createBook(CreateBookEvent event, WritingHomeEmitter emit) async {
    emit(WritingHomeStruct(
        books: state.books,
        loadingStruct: LoadingStruct(
            isLoading: event.isLoading, message: "Creating book")));
    Book? newBook = await repository.createBook(title: event.title);

    if (newBook != null) {
      emit(WritingHomeStruct(
          books: [...state.books, newBook],
          loadingStruct: LoadingStruct.loading(false)));
    } else {
      emit(WritingHomeStruct(
          books: state.books, loadingStruct: LoadingStruct.loading(false)));
    }

    // update books
    add(GetBooksEvent());
  }

  void openBook(OpenBookEvent event, WritingHomeEmitter emit) async {
    emit(WritingHomeStruct(
        books: state.books,
        loadingStruct: LoadingStruct.loading(false),
        bookToNavigate: event.book));
  }
}
