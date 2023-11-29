part of 'reading_hub_bloc.dart';

///
abstract class ReadingHomeEvent {
  final bool isLoading;
  const ReadingHomeEvent({required this.isLoading});
}

class AddLibraryBookEvent extends ReadingHomeEvent {
  int bookId;
  AddLibraryBookEvent({required this.bookId}) : super(isLoading: true);
}

class RemoveLibraryBookEvent extends ReadingHomeEvent {
  int bookId;
  RemoveLibraryBookEvent({required this.bookId}) : super(isLoading: true);
}

class InitialLoadEvent extends ReadingHomeEvent {
  InitialLoadEvent() : super(isLoading: true);
}

class FetchBooksEvent extends ReadingHomeEvent {
  const FetchBooksEvent() : super(isLoading: true);
}
