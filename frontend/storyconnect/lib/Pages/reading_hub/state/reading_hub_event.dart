part of 'reading_hub_bloc.dart';

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

class UpdateLibraryBookStatusEvent extends ReadingHomeEvent {
  int status;
  int bookId;
  UpdateLibraryBookStatusEvent({required this.bookId, required this.status})
      : super(isLoading: true);
}

class InitialLoadEvent extends ReadingHomeEvent {
  InitialLoadEvent() : super(isLoading: true);
}

class FetchBooksEvent extends ReadingHomeEvent {
  const FetchBooksEvent() : super(isLoading: true);
}

class FetchLibraryBooksEvent extends ReadingHomeEvent {
  const FetchLibraryBooksEvent() : super(isLoading: true);
}
