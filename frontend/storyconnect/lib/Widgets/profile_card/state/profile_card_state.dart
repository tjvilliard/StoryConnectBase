part of 'profile_card_bloc.dart';

@freezed
class ProfileCardState with _$ProfileCardState {
  const factory ProfileCardState({
    required String uid,
    Uint8List? tempProfileImage,
    String? tempDisplayName,
    String? bioEditingState,
    required Profile profile,
    required bool isUploadingProfileImage,
    required LoadingStruct loadingStruct,
    required bool isEditing,
    required List<String> responseMessages,
  }) = _ProfileCardState;
  const ProfileCardState._();

  factory ProfileCardState.initial(String uid) => ProfileCardState(
        uid: uid,
        profile: Profile.initial(),
        isUploadingProfileImage: false,
        loadingStruct: LoadingStruct.loading(true),
        isEditing: false,
        responseMessages: [],
      );
}
