import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:replay_bloc/replay_bloc.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Constants/search_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'search_bloc.freezed.dart';

abstract class SearchEvent {}

class SearchChangedEvent extends SearchEvent {
  String? search;
  SearchChangedEvent({required this.search});
}

class LanguageChangedEvent extends SearchEvent {
  LanguageConstant? language;
  LanguageChangedEvent({required this.language});
}

class CopyrightChangedEvent extends SearchEvent {
  CopyrightOption? copyright;
  CopyrightChangedEvent({required this.copyright});
}

class AudienceChangedEvent extends SearchEvent {
  TargetAudience? audience;
  AudienceChangedEvent({required this.audience});
}

class SearchModeChangedEvent extends SearchEvent {
  SearchModeConstant mode;
  SearchModeChangedEvent({required this.mode});
}

class ClearResultsEvent extends SearchEvent {}

class ClearSearchEvent extends SearchEvent {}

class QueryEvent extends SearchEvent {}

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required LoadingStruct loadingStruct,
    required bool initLoad,
    String? search,
    LanguageConstant? language,
    CopyrightOption? copyright,
    TargetAudience? audience,
    required SearchModeConstant searchMode,
    required List<Book> queryResults,
  }) = _SearchState;
  const SearchState._();

  /// 'Initial' or 'default' state of
  /// the Search - BLOC.
  factory SearchState.initial() {
    return const SearchState(
        search: null,
        language: null,
        copyright: null,
        audience: null,
        initLoad: true,
        loadingStruct: LoadingStruct(),
        queryResults: [],
        searchMode: SearchModeConstant.story);
  }
}

typedef SearchEmitter = Emitter<SearchState>;

/// State Management Object for the Search Bar and it's
/// associated filter options.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final ReadingRepository _repo;

  SearchBloc(this._repo) : super(SearchState.initial()) {
    on<SearchChangedEvent>((event, emit) => searchChanged(event, emit));
    on<LanguageChangedEvent>((event, emit) => languageChanged(event, emit));
    on<CopyrightChangedEvent>((event, emit) => copyrightChanged(event, emit));
    on<AudienceChangedEvent>((event, emit) => audienceChanged(event, emit));
    on<SearchModeChangedEvent>((event, emit) => searchModeChanged(event, emit));
    on<QueryEvent>((event, emit) => query(event, emit));
    on<ClearSearchEvent>((event, emit) => clearSearch(event, emit));
    on<ClearResultsEvent>((event, emit) => clearResults(event, emit));
  }

  searchChanged(SearchChangedEvent event, SearchEmitter emit) {
    emit(state.copyWith(search: event.search));
  }

  searchModeChanged(SearchModeChangedEvent event, SearchEmitter emit) {
    emit(state.copyWith(searchMode: event.mode));
  }

  languageChanged(LanguageChangedEvent event, SearchEmitter emit) {
    emit(state.copyWith(language: event.language));
  }

  copyrightChanged(CopyrightChangedEvent event, SearchEmitter emit) {
    emit(state.copyWith(copyright: event.copyright));
  }

  audienceChanged(AudienceChangedEvent event, SearchEmitter emit) {
    emit(state.copyWith(audience: event.audience));
  }

  query(QueryEvent event, SearchEmitter emit) async {
    emit(state.copyWith(loadingStruct: const LoadingStruct(isLoading: true)));
    List<Book> list = await _repo.getBookByFilter(state.search, state.language,
        state.copyright, state.audience, state.searchMode);

    print("Audience ${state.audience}");
    print("Copyright ${state.copyright}");
    print("Language ${state.language}");
    print("Search Mode: ${state.searchMode}");
    print("Search: ${state.search}");

    emit(state.copyWith(
        initLoad: false,
        loadingStruct: const LoadingStruct(isLoading: false),
        queryResults: list));
  }

  clearSearch(ClearSearchEvent event, SearchEmitter emit) async {
    emit(state.copyWith(
      search: null,
    ));
  }

  clearResults(ClearResultsEvent event, SearchEmitter emit) async {
    emit(state.copyWith(
      queryResults: [],
      initLoad: true,
    ));
  }
}
