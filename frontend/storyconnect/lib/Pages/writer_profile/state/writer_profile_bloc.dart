import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writer_profile/models/writer_profile_models.dart';
import 'package:storyconnect/Repositories/profile_repository.dart';

part 'writer_profile_events.dart';
part 'writer_profile_state.dart';
part 'writer_profile_bloc.freezed.dart';

typedef WriterProfileEmitter = Emitter<WriterProfileState>;

class WriterProfileBloc extends Bloc<WriterProfileEvent, WriterProfileState> {
  final ProfileRepository _repo;
  WriterProfileBloc(ProfileRepository repo)
      : _repo = repo,
        super(WriterProfileState.initial()) {
    on<WriterProfileLoadEvent>((event, emit) => load(event, emit));
    on<MakeAnnouncementEvent>((event, emit) => makeAnnouncement(event, emit));
    on<RecievedProfileEvent>((event, emit) => recievedProfile(event, emit));
    on<RecievedBooks>((event, emit) => recievedBooks(event, emit));
    on<ClearLastResponseEvent>((event, emit) => clearLastResponse(event, emit));
    on<RecievedActivitiesEvent>(
        (event, emit) => recievedActivities(event, emit));
    on<RecievedAnnouncementsEvent>(
        (event, emit) => recievedAnnouncements(event, emit));
  }

  load(WriterProfileLoadEvent event, WriterProfileEmitter emit) async {
    emit(state.copyWith(
      profileLoadingStruct: LoadingStruct.message("Loading profile"),
      booksLoadingStruct: LoadingStruct.message("Loading books"),
      annoucementsLoadingStruct: LoadingStruct.message("Loading announcements"),
      activitiesLoadingStruct: LoadingStruct.message("Loading activities"),
    ));

    _repo
        .getBooksByUser(event.uid)
        .then((value) => add(RecievedBooks(books: value)));
    _repo
        .getAnnouncements(event.uid)
        .then((value) => add(RecievedAnnouncementsEvent(announcements: value)));
    _repo
        .getProfile(event.uid)
        .then((value) => add(RecievedProfileEvent(profile: value)));

    _repo
        .getActivities(event.uid)
        .then((value) => add(RecievedActivitiesEvent(activities: value)));
  }

  makeAnnouncement(
      MakeAnnouncementEvent event, WriterProfileEmitter emit) async {
    final response = await _repo.makeAnnouncement(event.title, event.content);

    if (response) {
      emit(state.copyWith(
        responseMessages: ["Announcement made successfully"],
      ));
    } else {
      emit(state.copyWith(
        responseMessages: ["Announcement failed to make"],
      ));
    }
  }

  recievedProfile(RecievedProfileEvent event, WriterProfileEmitter emit) {
    emit(state.copyWith(
        profile: event.profile,
        profileLoadingStruct: LoadingStruct.loading(false)));
  }

  recievedBooks(RecievedBooks event, WriterProfileEmitter emit) {
    emit(state.copyWith(
        books: event.books, booksLoadingStruct: LoadingStruct.loading(false)));
  }

  recievedAnnouncements(
      RecievedAnnouncementsEvent event, WriterProfileEmitter emit) {
    emit(state.copyWith(
        announcements: event.announcements,
        annoucementsLoadingStruct: LoadingStruct.loading(false)));
  }

  clear(WriterProfileEventClearEvent event, WriterProfileEmitter emit) {
    emit(WriterProfileState.initial());
  }

  clearLastResponse(ClearLastResponseEvent event, WriterProfileEmitter emit) {
    final responses = List<String>.from(state.responseMessages);
    responses.removeLast();

    emit(state.copyWith(responseMessages: responses));
  }

  recievedActivities(RecievedActivitiesEvent event, WriterProfileEmitter emit) {
    emit(state.copyWith(
        activities: event.activities,
        activitiesLoadingStruct: LoadingStruct.loading(false)));
  }
}
