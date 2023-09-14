part of 'road_unblocker_bloc.dart';

@freezed
class RoadUnblockerState with _$RoadUnblockerState {
  const factory RoadUnblockerState({
    required LoadingStruct loadingStruct,
    required String chapter,
    String? question,
    String? selection,
    RoadUnblockerResponse? response,
  }) = _RoadUnblockerState;
  const RoadUnblockerState._();

  // initial state
  factory RoadUnblockerState.initial({
    required String currentChapterText,
  }) {
    return RoadUnblockerState(
      loadingStruct: LoadingStruct.loading(true),
      chapter: currentChapterText,
    );
  }
}
