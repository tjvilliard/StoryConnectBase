import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:replay_bloc/replay_bloc.dart';
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
  String? language;
  LanguageChangedEvent({required this.language});
}

class CopyrightChangedEvent extends SearchEvent {
  int? copyright;
  CopyrightChangedEvent({required this.copyright});
}

class AudienceChangedEvent extends SearchEvent {
  int? audience;
  AudienceChangedEvent({required this.audience});
}

class ClearStateEvent extends SearchEvent {}

class QueryEvent extends SearchEvent {}

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required LoadingStruct loadingStruct,
    String? search,
    String? language,
    int? copyright,
    int? audience,
    required List<Book> queryResults,
  }) = _SearchState;
  const SearchState._();

  /// 'Initial' or 'default' state of
  /// the Search - BLOC.
  factory SearchState.initial() {
    return const SearchState(loadingStruct: LoadingStruct(), queryResults: []);
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
    on<QueryEvent>((event, emit) => query(event, emit));
    on<ClearStateEvent>((event, emit) => clear(event, emit));
  }

  searchChanged(SearchChangedEvent event, SearchEmitter emit) {
    emit(state.copyWith(search: event.search));
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

    List<Book> list = await _repo.getBookByFilter(
        state.search, state.language, state.copyright, state.audience);

    emit(state.copyWith(
        loadingStruct: const LoadingStruct(isLoading: false),
        queryResults: list));
  }

  clear(ClearStateEvent event, SearchEmitter emit) async {
    emit(state.copyWith(
      search: null,
      language: null,
      copyright: null,
      audience: null,
    ));
  }
}
