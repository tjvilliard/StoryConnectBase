part of 'library_bloc.dart';

abstract class LibraryEvent {
  bool isLoading;
  LibraryEvent({required this.isLoading});
}

class GetLibraryEvent extends LibraryEvent {
  GetLibraryEvent() : super(isLoading: true);
}

class AddBookEvent extends LibraryEvent {
  int bookId;
  AddBookEvent({required this.bookId}) : super(isLoading: true);
}

class RemoveBookEvent extends LibraryEvent {
  int bookId;
  RemoveBookEvent({required this.bookId}) : super(isLoading: true);
}

class InitialLoadEvent extends LibraryEvent {
  InitialLoadEvent() : super(isLoading: true);
}
