part of 'library_bloc.dart';

abstract class LibraryEvent {
  const LibraryEvent();
}

class FetchLibraryBooksEvent extends LibraryEvent {
  const FetchLibraryBooksEvent();
}

class AddBookToLibraryEvent extends LibraryEvent {
  final int bookId;
  const AddBookToLibraryEvent({
    required this.bookId,
  });
}

class RemoveBookFromLibraryEvent extends LibraryEvent {
  final int bookId;
  const RemoveBookFromLibraryEvent({
    required this.bookId,
  });
}

class UpdateLibraryBookStatusEvent extends LibraryEvent {
  final int newStatus;
  final int bookId;
  const UpdateLibraryBookStatusEvent({
    required this.newStatus,
    required this.bookId,
  });
}

class SetLibraryBookToReadingEvent extends UpdateLibraryBookStatusEvent {
  const SetLibraryBookToReadingEvent({required super.bookId})
      : super(newStatus: 1);
}

class SetLibraryBookToCompletedEvent extends UpdateLibraryBookStatusEvent {
  const SetLibraryBookToCompletedEvent({required super.bookId})
      : super(newStatus: 2);
}

class SetLibraryBookToUnreadEvent extends UpdateLibraryBookStatusEvent {
  const SetLibraryBookToUnreadEvent({required super.bookId})
      : super(newStatus: 3);
}
