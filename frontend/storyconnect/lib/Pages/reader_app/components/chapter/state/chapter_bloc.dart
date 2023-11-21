import 'package:replay_bloc/replay_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reader_app/components/reading_pages_repository.dart';

part 'chapter_event.dart';
part 'chapter_bloc_struct.dart';

typedef ChapterEmitter = Emitter<ChapterBlocStruct>;

class ChapterBloc extends Bloc<ChapterEvent, ChapterBlocStruct> {
  /// Maps the chapter number as we see it to the chapter Id as the Backend and Database sees it.

  int get currentChapterId => state.chapterNumToID[state.currentChapterIndex]!;

  late final BookProviderRepository _repo;
  ChapterBloc(BookProviderRepository repository)
      : super(ChapterBlocStruct.initial()) {
    _repo = repository;
    on<SwitchChapter>((event, emit) => switchChapter(event, emit));
    on<LoadEvent>((event, emit) => loadEvent(event, emit));
  }

  void switchChapter(SwitchChapter event, ChapterEmitter emit) async {
    emit(state.copyWith(
      chapterIndex: event.chapterToSwitchTo,
    ));
  }

  /// Parses the list of chapters from the backend, mapping the
  /// chapter numbers from index -> ID and index -> Content.
  Map<int, String> parseChapters(List<Chapter> chapters) {
    Map<int, String> parsedChapters = {};
    for (Chapter chapter in chapters) {
      state.chapterNumToID[chapter.number] = chapter.id;
      parsedChapters[chapter.number] = chapter.chapterContent;
    }
    return parsedChapters;
  }

  void loadEvent(LoadEvent event, Emitter<ChapterBlocStruct> emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.message("Loading Book")));
    final unParsedChapters = await _repo.getChapters();

    final chapters = parseChapters(unParsedChapters);

    emit(state.copyWith(
        chapters: chapters, loadingStruct: LoadingStruct.loading(false)));
  }
}
