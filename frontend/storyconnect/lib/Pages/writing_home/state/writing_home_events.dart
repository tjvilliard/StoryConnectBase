part of 'writing_home_bloc.dart';

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

class SearchBooksEvent extends WritingHomeEvent {
  final String query;
  SearchBooksEvent(this.query) : super(isLoading: true);
}
