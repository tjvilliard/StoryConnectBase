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

class SubmitUnblockEvent extends RoadUnblockerEvent {
  final int chapterID;
  final String selection;
  const SubmitUnblockEvent({required this.chapterID, required this.selection});
}

class RecieveUnblockEvent extends RoadUnblockerEvent {
  final RoadUnblockerResponse response;
  const RecieveUnblockEvent({required this.response});
}

class AcceptSuggestionEvent extends RoadUnblockerEvent {
  final String responseLocalId;
  final String localId;
  final WritingBloc writingBloc;
  const AcceptSuggestionEvent({required this.responseLocalId, required this.localId, required this.writingBloc});
}

class RejectSuggestionEvent extends RoadUnblockerEvent {
  final String responseLocalId;
  final String localId;
  const RejectSuggestionEvent({required this.responseLocalId, required this.localId});
}

class ClearUnblockEvent extends RoadUnblockerEvent {
  const ClearUnblockEvent();
}
