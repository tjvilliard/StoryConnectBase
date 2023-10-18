part of 'library_bloc.dart';

abstract class LibraryEvent {
  bool isLoading;
  LibraryEvent({required this.isLoading});
}

class GetLibraryEvent extends LibraryEvent {
  GetLibraryEvent() : super(isLoading: true);
}

class InitialLoadEvent extends LibraryEvent {
  InitialLoadEvent() : super(isLoading: true);
}
