import 'package:bloc/bloc.dart';

class WritingUIStatus {
  final bool chapterOutlineShown;
  WritingUIStatus({required this.chapterOutlineShown});
}

class WritingUIEvent {
  WritingUIStatus status;
  WritingUIEvent({required this.status});
}

typedef WritingUIEmiter = Emitter<WritingUIStatus>;

class WritingUIBloc extends Bloc<WritingUIEvent, WritingUIStatus> {
  WritingUIBloc() : super(WritingUIStatus(chapterOutlineShown: false)) {
    on<WritingUIEvent>((event, emit) => updateUI(event, emit));
  }
  updateUI(WritingUIEvent event, WritingUIEmiter emit) {
    emit(event.status);
  }

  void toggleChapterOutline() {
    add(WritingUIEvent(
        status:
            WritingUIStatus(chapterOutlineShown: !state.chapterOutlineShown)));
  }
}
