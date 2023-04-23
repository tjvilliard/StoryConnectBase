import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_home/writing_repository.dart';

abstract class WritingHomeEvent {}

class RecievedBooksEvent extends WritingHomeEvent {
  final List<Book> books;
  RecievedBooksEvent({required this.books});
}

class CreateBookEvent extends WritingHomeEvent {
  CreateBookEvent();
}

class WritingHomeStruct {
  final List<Book> books;

  WritingHomeStruct({required this.books});
}

typedef WritingHomeEmitter = Emitter<WritingHomeStruct>;

class WritingHomeBloc extends Bloc<WritingHomeEvent, WritingHomeStruct> {
  late final WritingHomeRepository repository;
  WritingHomeBloc({required this.repository})
      : super(WritingHomeStruct(books: [])) {
    on<RecievedBooksEvent>((event, emit) => updateBooks(event, emit));
    on<CreateBookEvent>((event, emit) => createBook(event, emit));
  }

  void updateBooks(WritingHomeEvent event, WritingHomeEmitter emit) {}
  void createBook(CreateBookEvent event, WritingHomeEmitter emit) async {
    Book newBook = await repository.createBook();

    // Update the state with the new book
    emit(WritingHomeStruct(books: [...state.books, newBook]));
  }
}
