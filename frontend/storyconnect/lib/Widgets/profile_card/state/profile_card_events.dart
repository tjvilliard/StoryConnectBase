part of 'profile_card_bloc.dart';

abstract class ProfileCardEvent {
  const ProfileCardEvent();
}

class ProfileCardLoadEvent extends ProfileCardEvent {
  final String uid;
  const ProfileCardLoadEvent({required this.uid});
}

class RecievedProfileEvent extends ProfileCardEvent {
  final Profile profile;

  const RecievedProfileEvent({required this.profile});
}

class ProfileCardEventClearEvent extends ProfileCardEvent {
  const ProfileCardEventClearEvent();
}

class EditProfileEvent extends ProfileCardEvent {
  const EditProfileEvent();
}

class EditBioStateEvent extends ProfileCardEvent {
  final String bio;
  const EditBioStateEvent({required this.bio});
}

class SaveProfileEvent extends ProfileCardEvent {
  const SaveProfileEvent();
}

class CancelProfileEditEvent extends ProfileCardEvent {
  const CancelProfileEditEvent();
}

class SelectProfileImageEvent extends ProfileCardEvent {
  const SelectProfileImageEvent();
}

class SaveProfileImageEvent extends ProfileCardEvent {
  const SaveProfileImageEvent();
}

class DeleteProfileImageEvent extends ProfileCardEvent {
  const DeleteProfileImageEvent();
}

class ClearProfileImageEvent extends ProfileCardEvent {
  const ClearProfileImageEvent();
}

class EditDisplayNameEvent extends ProfileCardEvent {
  final String displayName;
  const EditDisplayNameEvent({required this.displayName});
}

class ClearShownResponseEvent extends ProfileCardEvent {
  const ClearShownResponseEvent();
}
