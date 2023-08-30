part of 'book_create_bloc.dart';

abstract class BookCreateEvent {
  const BookCreateEvent();
}

class AuthorChangedEvent extends BookCreateEvent {
  final String author;
  const AuthorChangedEvent({required this.author});
}

class TitleChangedEvent extends BookCreateEvent {
  final String title;
  const TitleChangedEvent({required this.title});
}

class SaveBookEvent extends BookCreateEvent {
  const SaveBookEvent();
}
