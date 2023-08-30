import 'package:bloc/bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_home/writing_repository.dart';

class WritingUIStruct {
  final bool chapterOutlineShown;
  final String? title;
  final LoadingStruct loadingStruct;
  WritingUIStruct(
      {required this.chapterOutlineShown,
      required this.loadingStruct,
      this.title});

  WritingUIStruct copyWith({
    bool? chapterOutlineShown,
    String? title,
    LoadingStruct? loadingStruct,
  }) {
    return WritingUIStruct(
      chapterOutlineShown: chapterOutlineShown ?? this.chapterOutlineShown,
      title: title ?? this.title,
      loadingStruct: loadingStruct ?? this.loadingStruct,
    );
  }
}

abstract class WritingUIEvent {
  WritingUIEvent();
}

class UpdateAllEvent extends WritingUIEvent {
  final WritingUIStruct status;
  UpdateAllEvent({required this.status});
}

class WritingLoadEvent extends WritingUIEvent {
  final int bookId;
  final ChapterBloc chapterBloc;
  WritingLoadEvent({
    required this.bookId,
    required this.chapterBloc,
  });
}

typedef WritingUIEmiter = Emitter<WritingUIStruct>;

class WritingUIBloc extends Bloc<WritingUIEvent, WritingUIStruct> {
  WritingRepository repository = WritingRepository();
  WritingUIBloc({required this.repository})
      : super(WritingUIStruct(
            chapterOutlineShown: false,
            loadingStruct: LoadingStruct.loading(true))) {
    on<UpdateAllEvent>((event, emit) => updateUI(event, emit));
    on<WritingLoadEvent>((event, emit) => loadEvent(event, emit));
  }
  updateUI(UpdateAllEvent event, WritingUIEmiter emit) {
    emit(event.status);
  }

  Future<String> _getBookTitle(int bookId) async {
    for (final book in repository.books) {
      if (book.id == bookId) {
        return book.title;
      }
    }
    final books = await repository.getBooks();
    for (final book in books) {
      if (book.id == bookId) {
        return book.title;
      }
    }
    return "Error: Title not found";
  }

  Future<void> loadEvent(WritingLoadEvent event, WritingUIEmiter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.loading(true)));
    event.chapterBloc.add(LoadEvent());

    final title = await _getBookTitle(event.bookId);

    emit(state.copyWith(
        loadingStruct: LoadingStruct.loading(false), title: title));
  }

  void toggleChapterOutline() {
    add(UpdateAllEvent(
        status:
            state.copyWith(chapterOutlineShown: !state.chapterOutlineShown)));
  }
}
