import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';

abstract class WritingHomeEvent {
  bool isLoading;
  WritingHomeEvent({required this.isLoading});
}

class GetBooksEvent extends WritingHomeEvent {
  GetBooksEvent() : super(isLoading: true);
}

class InitialLoadEvent extends WritingHomeEvent {
  InitialLoadEvent() : super(isLoading: true);
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
  }

  void updateBooks(WritingHomeEvent event, WritingHomeEmitter emit) async {
    emit(WritingHomeStruct(
        books: state.books,
        loadingStruct: LoadingStruct.loading(event.isLoading)));
    List<Book> books = await repository.getBooks();
    emit(WritingHomeStruct(
        books: books, loadingStruct: LoadingStruct.loading(false)));
  }
}
