part of 'reading_home_bloc.dart';

///
class ReadingHomeStruct {
  final List<Book> books;
  final Book? bookToNavigate;
  final LoadingStruct loadingStruct;

  ReadingHomeStruct({
    required this.books,
    required this.loadingStruct,
    this.bookToNavigate,
  });
}
