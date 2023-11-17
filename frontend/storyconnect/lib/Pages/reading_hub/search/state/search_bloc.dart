import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:replay_bloc/replay_bloc.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_bloc.freezed.dart';

typedef SearchEmitter = Emitter<SearchState>;

/// State Management Object for the Search Bar and it's
/// associated filter options.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final ReadingRepository _repo;

  SearchBloc(this._repo) : super(SearchState()) {}

  /// Handles the changing of the type of query.
  /// <br/> Query Types Supported?:
  ///   + Author profile or books written by author.
  ///   + Books that contain a certain word or phrase anywhere in the book: Title, Synopsis, or Chapter.
  ///   + Books with phrase in the title.
  ///   + Books with phrase in the synopsis.
  void queryTypeChanged(SearchEvent event, SearchEmitter emit) {}

  /// Handles the changing of the search box contents.
  void searchFieldChanged(SearchEvent event, SearchEmitter emit) {}

  /// Handles the changing of the state of a filter.
  void filterStateChanged(SearchEvent event, SearchEmitter emit) {
    //TODO: implement multiple filter methods.
  }
}
