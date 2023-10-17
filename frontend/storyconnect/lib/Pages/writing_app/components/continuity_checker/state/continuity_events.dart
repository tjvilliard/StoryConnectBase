part of 'continuity_bloc.dart';

abstract class ContinuityEvent {
  const ContinuityEvent();
}

class GenerateContinuitiesEvent extends ContinuityEvent {
  final int chapterId;
  const GenerateContinuitiesEvent(
    this.chapterId,
  );
}

class DismissContinuityEvent extends ContinuityEvent {
  final String uuid;
  const DismissContinuityEvent(
    this.uuid,
  );
}
