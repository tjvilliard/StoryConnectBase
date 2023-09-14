part of 'road_unblocker_bloc.dart';

abstract class RoadUnblockerEvent {
  const RoadUnblockerEvent();
}

class UpdateChapterEvent extends RoadUnblockerEvent {
  final String chapter;
  const UpdateChapterEvent({required this.chapter});
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
  const SubmitUnblockEvent();
}

class RecieveUnblockEvent extends RoadUnblockerEvent {
  final RoadUnblockerResponse response;
  const RecieveUnblockEvent({required this.response});
}

class ClearUnblockEvent extends RoadUnblockerEvent {
  const ClearUnblockEvent();
}
