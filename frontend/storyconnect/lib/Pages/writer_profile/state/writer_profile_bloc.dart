import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writer_profile/models/writer_profile_models.dart';
import 'package:storyconnect/Repositories/core_repository.dart';
part 'writer_profile_events.dart';
part 'writer_profile_state.dart';
part 'writer_profile_bloc.freezed.dart';

typedef WriterProfileEmitter = Emitter<WriterProfileState>;

class WriterProfileBloc extends Bloc<WriterProfileEvent, WriterProfileState> {
  final CoreRepository _repo;
  WriterProfileBloc(CoreRepository repo)
      : _repo = repo,
        super(WriterProfileState.initial()) {
    on<WriterProfileLoadEvent>((event, emit) => load(event, emit));
    on<MakeAnnouncementEvent>((event, emit) => makeAnnouncement(event, emit));

    on<ClearLastResponseEvent>((event, emit) => clearLastResponse(event, emit));
    on<RecievedProfileEvent>(
      (event, emit) => recievedProfile(event, emit),
    );
    on<RecievedBooks>(
      (event, emit) => recievedBooks(event, emit),
    );
    on<RecievedActivitiesEvent>(
      (event, emit) => recievedActivities(event, emit),
    );
    on<RecievedAnnouncementsEvent>(
      (event, emit) => recievedAnnouncements(event, emit),
    );
    on<EditBioEvent>((event, emit) => editBio(event, emit));
    on<SaveBioEvent>((event, emit) => saveBio(event, emit));
    on<CancelBioEvent>((event, emit) => cancelBio(event, emit));
    on<EditBioStateEvent>((event, emit) => editBioState(event, emit));
    on<SaveProfileImageEvent>((event, emit) => saveProfileImage(event, emit));
    on<SelectProfileImageEvent>((event, emit) => selectProfileImage(event, emit));
    on<ClearProfileImageEvent>((event, emit) => clearProfileImage(event, emit));
    on<DeleteProfileImageEvent>((event, emit) => deleteProfileImage(event, emit));
  }

  load(WriterProfileLoadEvent event, WriterProfileEmitter emit) async {
    emit(state.copyWith(
        loadingStructs: state.loadingStructs.copyWith(
      profileLoadingStruct: LoadingStruct.message("Loading profile"),
      booksLoadingStruct: LoadingStruct.message("Loading books"),
      annoucementsLoadingStruct: LoadingStruct.message("Loading announcements"),
      activitiesLoadingStruct: LoadingStruct.message("Loading activities"),
    )));

    _repo.getBooksByUser(event.uid).then((value) => add(RecievedBooks(books: value)));
    _repo.getAnnouncements(event.uid).then((value) => add(RecievedAnnouncementsEvent(announcements: value)));

    _repo.getActivities(event.uid).then((value) => add(RecievedActivitiesEvent(activities: value)));
    _repo.getProfile(event.uid).then((value) => add(RecievedProfileEvent(profile: value)));
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

  recievedProfile(RecievedProfileEvent event, WriterProfileEmitter emit) {
    emit(state.copyWith(
        profile: event.profile,
        loadingStructs: state.loadingStructs.copyWith(profileLoadingStruct: LoadingStruct.loading(false))));
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
        loadingStructs: state.loadingStructs.copyWith(activitiesLoadingStruct: LoadingStruct.loading(false))));
  }

  editBio(EditBioEvent event, WriterProfileEmitter emit) {
    emit(state.copyWith(isEditingBio: true));
  }

  saveBio(SaveBioEvent event, WriterProfileEmitter emit) async {
    emit(state.copyWith(
        loadingStructs: state.loadingStructs.copyWith(
      profileLoadingStruct: LoadingStruct.message("Saving bio"),
    )));
    if (state.bioEditingState != null) {
      final response = await _repo.updateBio(state.profile.copyWith(bio: state.bioEditingState!));
      if (response != null) {
        emit(state.copyWith(
          isEditingBio: false,
          profile: response,
          loadingStructs: state.loadingStructs.copyWith(
            profileLoadingStruct: LoadingStruct.loading(false),
          ),
          responseMessages: ["Bio updated successfully"],
        ));
      } else {
        emit(state.copyWith(
          loadingStructs: state.loadingStructs.copyWith(profileLoadingStruct: LoadingStruct.loading(false)),
          responseMessages: ["Failed to update bio"],
        ));
      }
    }
  }

  cancelBio(CancelBioEvent event, WriterProfileEmitter emit) {
    emit(state.copyWith(isEditingBio: false));
  }

  editBioState(EditBioStateEvent event, WriterProfileEmitter emit) {
    emit(state.copyWith(bioEditingState: event.bio));
  }

  saveProfileImage(SaveProfileImageEvent event, WriterProfileEmitter emit) {}

  selectProfileImage(SelectProfileImageEvent event, WriterProfileEmitter emit) async {
    FilePicker platformFilePicker = FilePicker.platform;
    FilePickerResult? result = await platformFilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      // get file from bytes since web doesn't support path
      emit(state.copyWith(tempProfileImage: result.files.single.bytes));
    }
  }

  clearProfileImage(ClearProfileImageEvent event, WriterProfileEmitter emit) {}

  deleteProfileImage(DeleteProfileImageEvent event, WriterProfileEmitter emit) {}
}
