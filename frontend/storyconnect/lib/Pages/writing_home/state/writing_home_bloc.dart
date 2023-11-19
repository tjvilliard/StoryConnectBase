import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';

part 'writing_home_state.dart';
part 'writing_home_bloc.freezed.dart';
part 'writing_home_events.dart';

typedef WritingHomeEmitter = Emitter<WritingHomeState>;

class WritingHomeBloc extends Bloc<WritingHomeEvent, WritingHomeState> {
  late final WritingRepository repository;
  WritingHomeBloc(this.repository) : super(WritingHomeState.initial()) {
    on<GetBooksEvent>((event, emit) => updateBooks(event, emit));
    on<InitialLoadEvent>((event, emit) => updateBooks(event, emit));
    on<SearchBooksEvent>((event, emit) => searchBooks(event, emit));
  }

  void updateBooks(WritingHomeEvent event, WritingHomeEmitter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.loading(true)));
    List<Book> books = await repository.getBooks();
    emit(state.copyWith(books: books, loadingStruct: LoadingStruct.loading(false)));
  }

  void searchBooks(SearchBooksEvent event, WritingHomeEmitter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.loading(true)));
    List<Book> searchingBooks = state.books.where((Book book) => book.title.contains(event.query)).toList();
    emit(state.copyWith(searchingBooks: searchingBooks, loadingStruct: LoadingStruct.loading(false)));
  }
}
