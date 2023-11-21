part of 'writer_profile_bloc.dart';

@freezed
class WriterProfileState with _$WriterProfileState {
  const factory WriterProfileState({
    required Profile profile,
    required List<Book> books,
    required List<Announcement> announcements,
    required List<Activity> activities,
    required List<String> responseMessages,
    required bool isEditingBio,
    String? bioEditingState,
    Uint8List? tempProfileImage,
    String? tempDisplayName,
    required bool isUploadingProfileImage,
    required WritingProfileLoadingStructs loadingStructs,
  }) = _WriterProfileState;

  factory WriterProfileState.initial() => WriterProfileState(
        profile: Profile.initial(),
        isEditingBio: false,
        books: [],
        announcements: [],
        responseMessages: [],
        activities: [],
        bioEditingState: null,
        loadingStructs: WritingProfileLoadingStructs.initial(),
        isUploadingProfileImage: false,
      );
}

@freezed
class WritingProfileLoadingStructs with _$WritingProfileLoadingStructs {
  const factory WritingProfileLoadingStructs({
    required LoadingStruct profileLoadingStruct,
    required LoadingStruct booksLoadingStruct,
    required LoadingStruct annoucementsLoadingStruct,
    required LoadingStruct activitiesLoadingStruct,
    required LoadingStruct makeAnnouncementLoadingStruct,
  }) = _WritingProfileLoadingStructs;

  factory WritingProfileLoadingStructs.initial() => WritingProfileLoadingStructs(
        profileLoadingStruct: LoadingStruct.loading(true),
        booksLoadingStruct: LoadingStruct.loading(true),
        annoucementsLoadingStruct: LoadingStruct.loading(true),
        activitiesLoadingStruct: LoadingStruct.loading(true),
        makeAnnouncementLoadingStruct: LoadingStruct.loading(false),
      );
}
