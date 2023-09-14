part of 'road_unblocker_bloc.dart';

@freezed
class RoadUnblockerState with _$RoadUnblockerState {
  const factory RoadUnblockerState({
    required LoadingStruct loadingStruct,
  }) = _RoadUnblockerState;
  const RoadUnblockerState._();

  // initial state
  factory RoadUnblockerState.initial() {
    return RoadUnblockerState(
      loadingStruct: LoadingStruct.loading(true),
    );
  }
}
