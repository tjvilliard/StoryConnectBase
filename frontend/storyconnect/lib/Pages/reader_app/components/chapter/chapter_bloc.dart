import 'package:replay_bloc/replay_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reader_app/components/pages_repository.dart';

part 'chapter_event.dart';
part 'chapter_bloc_struct.dart';

typedef ChapterEmitter = Emitter<ChapterBlocStruct>;

class ChapterBloc extends Bloc<ChapterEvent, ChapterBlocStruct> {
  final chapterNumToID = <int, int>{};

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

  Map<int, String> parseChapters(List<Chapter> chapters) {
    Map<int, String> parsedChapters = {};
    for (Chapter chapter in chapters) {
      chapterNumToID[chapter.number] = chapter.id;
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
