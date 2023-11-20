part of 'reading_home_bloc.dart';

///
abstract class ReadingHomeEvent {
  bool isLoading;
  ReadingHomeEvent({required this.isLoading});
}

class GetBooksEvent extends ReadingHomeEvent {
  GetBooksEvent() : super(isLoading: true);
}

class InitialLoadEvent extends ReadingHomeEvent {
  InitialLoadEvent() : super(isLoading: true);
}
