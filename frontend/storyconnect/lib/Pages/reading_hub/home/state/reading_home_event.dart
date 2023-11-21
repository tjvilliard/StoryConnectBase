part of 'reading_home_bloc.dart';

///
abstract class ReadingHomeEvent {
  final bool isLoading;
  const ReadingHomeEvent({required this.isLoading});
}

class GetBooksEvent extends ReadingHomeEvent {
  const GetBooksEvent() : super(isLoading: true);
}

class InitialLoadEvent extends ReadingHomeEvent {
  const InitialLoadEvent() : super(isLoading: true);
}
