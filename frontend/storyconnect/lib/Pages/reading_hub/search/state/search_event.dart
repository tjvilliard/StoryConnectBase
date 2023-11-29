part of 'search_bloc.dart';

abstract class SearchEvent extends ReplayEvent {
  bool isLoading;
  SearchEvent({required this.isLoading});
}
