import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Widgets/profile_card/state/profile_card_bloc.dart';
import 'package:storyconnect/Pages/writer_profile/models/writer_profile_models.dart';
import 'package:storyconnect/Repositories/core_repository.dart';
part 'writer_profile_events.dart';
part 'writer_profile_state.dart';
part 'writer_profile_bloc.freezed.dart';

typedef WriterProfileEmitter = Emitter<WriterProfileState>;

class WriterProfileBloc extends Bloc<WriterProfileEvent, WriterProfileState> {
  final CoreRepository _repo;
  WriterProfileBloc(CoreRepository repo, String uid)
      : _repo = repo,
        super(WriterProfileState.initial(uid)) {
    on<WriterProfileLoadEvent>((event, emit) => load(event, emit));
    on<MakeAnnouncementEvent>((event, emit) => makeAnnouncement(event, emit));

    on<ClearLastResponseEvent>((event, emit) => clearLastResponse(event, emit));

    on<RecievedBooks>(
      (event, emit) => recievedBooks(event, emit),
    );
    on<RecievedActivitiesEvent>(
      (event, emit) => recievedActivities(event, emit),
    );
    on<RecievedAnnouncementsEvent>(
      (event, emit) => recievedAnnouncements(event, emit),
    );

    add(WriterProfileLoadEvent(uid: uid));
  }

  load(WriterProfileLoadEvent event, WriterProfileEmitter emit) async {
    emit(state.copyWith(
        loadingStructs: state.loadingStructs.copyWith(
      booksLoadingStruct: LoadingStruct.message("Loading books"),
      annoucementsLoadingStruct: LoadingStruct.message("Loading announcements"),
      activitiesLoadingStruct: LoadingStruct.message("Loading activities"),
    )));

    _repo.getBooksByUser(event.uid).then((value) => add(RecievedBooks(books: value)));
    _repo.getAnnouncements(event.uid).then((value) => add(RecievedAnnouncementsEvent(announcements: value)));

    _repo.getActivities(event.uid).then((value) => add(RecievedActivitiesEvent(activities: value)));
  }

  makeAnnouncement(MakeAnnouncementEvent event, WriterProfileEmitter emit) async {
    final Announcement? response = await _repo.makeAnnouncement(event.title, event.content);

    if (response != null) {
      emit(state.copyWith(
        announcements: [response, ...state.announcements],
        responseMessages: ["Announcement made successfully"],
      ));
    } else {
      emit(state.copyWith(
        responseMessages: ["Announcement failed to make"],
      ));
    }
  }

  recievedBooks(RecievedBooks event, WriterProfileEmitter emit) {
    emit(state.copyWith(
        books: event.books,
        loadingStructs: state.loadingStructs.copyWith(booksLoadingStruct: LoadingStruct.loading(false))));
  }

  recievedAnnouncements(RecievedAnnouncementsEvent event, WriterProfileEmitter emit) {
    emit(state.copyWith(
        announcements: event.announcements,
        loadingStructs: state.loadingStructs.copyWith(annoucementsLoadingStruct: LoadingStruct.loading(false))));
  }

  clearLastResponse(ClearLastResponseEvent event, WriterProfileEmitter emit) {
    final responses = List<String>.from(state.responseMessages);
    responses.removeLast();

    emit(state.copyWith(responseMessages: responses));
  }

  recievedActivities(RecievedActivitiesEvent event, WriterProfileEmitter emit) {
    emit(state.copyWith(
        activities: event.activities,
        loadingStructs: state.loadingStructs.copyWith(activitiesLoadingStruct: LoadingStruct.loading(false))));
  }
}
