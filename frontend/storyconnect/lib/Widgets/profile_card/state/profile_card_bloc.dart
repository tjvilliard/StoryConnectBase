import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/core_repository.dart';

part 'profile_card_state.dart';
part 'profile_card_events.dart';
part 'profile_card_bloc.freezed.dart';

typedef ProfileCardEmitter = Emitter<ProfileCardState>;

class ProfileCardBloc extends Bloc<ProfileCardEvent, ProfileCardState> {
  final CoreRepository _repo;
  ProfileCardBloc(CoreRepository repo, String uid)
      : _repo = repo,
        super(ProfileCardState.initial(uid)) {
    on<EditProfileEvent>((event, emit) => editProfile(event, emit));
    on<SaveProfileEvent>((event, emit) => saveProfile(event, emit));
    on<CancelProfileEditEvent>((event, emit) => cancelProfileEdit(event, emit));
    on<EditBioStateEvent>((event, emit) => editBioState(event, emit));
    on<SaveProfileImageEvent>((event, emit) => saveProfileImage(event, emit));
    on<SelectProfileImageEvent>((event, emit) => selectProfileImage(event, emit));
    on<ClearProfileImageEvent>((event, emit) => clearProfileImage(event, emit));
    on<DeleteProfileImageEvent>((event, emit) => deleteProfileImage(event, emit));
    on<EditDisplayNameEvent>((event, emit) => editDisplayName(event, emit));
    on<ProfileCardLoadEvent>((event, emit) => load(event, emit));
    on<RecievedProfileEvent>((event, emit) => recievedProfile(event, emit));
    on<ClearShownResponseEvent>((event, emit) => clearShownResponse(event, emit));
    add(ProfileCardLoadEvent(uid: uid));
  }

  load(ProfileCardLoadEvent event, ProfileCardEmitter emit) async {
    emit(state.copyWith(
      loadingStruct: LoadingStruct.message("Loading profile"),
    ));

    final Profile? profile = await _repo.getProfile(event.uid);
    if (profile == null) {
      emit(state.copyWith(
        loadingStruct: LoadingStruct.loading(false),
        responseMessages: ["Failed to load profile"],
      ));
    } else {
      add(RecievedProfileEvent(profile: profile));
    }
  }

  void editProfile(EditProfileEvent event, ProfileCardEmitter emit) {
    emit(state.copyWith(
        isEditing: true, bioEditingState: state.profile.bio, tempDisplayName: state.profile.displayName));
  }

  void saveProfile(SaveProfileEvent event, ProfileCardEmitter emit) async {
    emit(state.copyWith(
      loadingStruct: LoadingStruct.message("Saving bio"),
    ));
    if (state.bioEditingState != null && state.tempDisplayName != null) {
      final response = await _repo
          .updateProfile(state.profile.copyWith(bio: state.bioEditingState!, displayName: state.tempDisplayName!));
      if (response != null) {
        emit(state.copyWith(
          isEditing: false,
          profile: response,
          loadingStruct: LoadingStruct.loading(false),
          responseMessages: ["Profile updated successfully"],
        ));
      } else {
        emit(state.copyWith(
          loadingStruct: LoadingStruct.loading(false),
          responseMessages: ["Failed to update profile. Please ensure you've set both a bio and a display name"],
        ));
      }
    }
  }

  cancelProfileEdit(CancelProfileEditEvent event, ProfileCardEmitter emit) {
    emit(state.copyWith(
      isEditing: false,
    ));
  }

  editBioState(EditBioStateEvent event, ProfileCardEmitter emit) {
    emit(state.copyWith(
      bioEditingState: event.bio,
    ));
  }

  void selectProfileImage(SelectProfileImageEvent event, ProfileCardEmitter emit) async {
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

  Future<void> saveProfileImage(SaveProfileImageEvent event, ProfileCardEmitter emit) async {
    if (state.tempProfileImage == null) {
      emit(state.copyWith(
        responseMessages: ["No image selected"],
      ));
      return;
    }

    emit(state.copyWith(
      loadingStruct: LoadingStruct.message("Saving profile image"),
    ));

    final results = await _repo.updateProfileImage(state.tempProfileImage!);

    if (results != null) {
      emit(state.copyWith(
        profile: results,
        isEditing: false,
        loadingStruct: LoadingStruct.loading(false),
        responseMessages: ["Profile image updated successfully"],
      ));
    } else {
      emit(state.copyWith(
        isEditing: false,
        loadingStruct: LoadingStruct.loading(false),
        responseMessages: ["Failed to update profile image"],
      ));
    }
  }

  Future<void> deleteProfileImage(DeleteProfileImageEvent event, ProfileCardEmitter emit) async {
    emit(state.copyWith(
      loadingStruct: LoadingStruct.message("Deleting profile image"),
    ));

    final GenericResponse results = await _repo.deleteProfileImage();

    if (results.success) {
      emit(state.copyWith(
        profile: state.profile.copyWith(imageUrl: null),
      ));
    }

    emit(state.copyWith(
      loadingStruct: LoadingStruct.loading(false),
      responseMessages: [results.message!],
    ));
  }

  editDisplayName(EditDisplayNameEvent event, ProfileCardEmitter emit) {
    emit(state.copyWith(tempDisplayName: event.displayName));
  }

  void clearProfileImage(ClearProfileImageEvent event, ProfileCardEmitter emit) {
    emit(state.copyWith(tempProfileImage: null));
  }

  recievedProfile(RecievedProfileEvent event, ProfileCardEmitter emit) {
    emit(state.copyWith(
      profile: event.profile,
      loadingStruct: LoadingStruct.loading(false),
    ));
  }

  clearShownResponse(ClearShownResponseEvent event, ProfileCardEmitter emit) {
    final List<String> newResponseMessages = List<String>.from(state.responseMessages);
    newResponseMessages.removeLast();
    emit(state.copyWith(responseMessages: newResponseMessages));
  }
}
