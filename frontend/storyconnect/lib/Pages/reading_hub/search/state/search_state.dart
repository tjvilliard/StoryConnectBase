part of 'search_bloc.dart';

///
@freezed
class SearchState with _$SearchState {
  const factory SearchState() = _SearchState;
  const SearchState._();

  /// 'Initial' or 'default' state of
  /// the Search - BLOC.
  factory SearchState.initial() {
    return const SearchState();
  }
}
