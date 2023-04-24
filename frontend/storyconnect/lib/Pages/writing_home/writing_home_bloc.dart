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
  int bookId;
  OpenBookEvent({required this.bookId}) : super(isLoading: true);
}

class BookToNavigate {
  final int bookId;
  BookToNavigate({required this.bookId});
}

class WritingHomeStruct {
  final List<Book> books;
  final BookToNavigate? bookToNavigate;
  final LoadingStruct loadingStruct;
  WritingHomeStruct(
      {required this.books, required this.loadingStruct, this.bookToNavigate});
}

typedef WritingHomeEmitter = Emitter<WritingHomeStruct>;

class WritingHomeBloc extends Bloc<WritingHomeEvent, WritingHomeStruct> {
  late final WritingHomeRepository repository;
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
    Book newBook = await repository.createBook(title: event.title);
    emit(WritingHomeStruct(
        books: [...state.books, newBook],
        loadingStruct: LoadingStruct.loading(false)));
  }

  void openBook(OpenBookEvent event, WritingHomeEmitter emit) async {
    emit(WritingHomeStruct(
        books: state.books,
        loadingStruct: LoadingStruct.loading(false),
        bookToNavigate: BookToNavigate(bookId: event.bookId)));
  }
}
