part of 'road_unblocker_bloc.dart';

abstract class RoadUnblockerEvent {
  const RoadUnblockerEvent();
}

class UnblockerUpdateChapterEvent extends RoadUnblockerEvent {
  final String chapter;
  const UnblockerUpdateChapterEvent({required this.chapter});
}

class OnGuidingQuestionChangedEvent extends RoadUnblockerEvent {
  final String question;
  const OnGuidingQuestionChangedEvent({required this.question});
}

class LoadSelectionEvent extends RoadUnblockerEvent {
  final int startOffset;
  final int endOffset;
  const LoadSelectionEvent(
      {required this.startOffset, required this.endOffset});
}

class SubmitUnblockEvent extends RoadUnblockerEvent {
  final int chapterID;
  const SubmitUnblockEvent({required this.chapterID});
}

class RecieveUnblockEvent extends RoadUnblockerEvent {
  final RoadUnblockerResponse response;
  const RecieveUnblockEvent({required this.response});
}

class AcceptSuggestionEvent extends RoadUnblockerEvent {
  final String responseLocalId;
  final String localId;
  final WritingBloc writingBloc;
  const AcceptSuggestionEvent(
      {required this.responseLocalId,
      required this.localId,
      required this.writingBloc});
}

class RejectSuggestionEvent extends RoadUnblockerEvent {
  final String responseLocalId;
  final String localId;
  const RejectSuggestionEvent(
      {required this.responseLocalId, required this.localId});
}

class ClearUnblockEvent extends RoadUnblockerEvent {
  const ClearUnblockEvent();
}
