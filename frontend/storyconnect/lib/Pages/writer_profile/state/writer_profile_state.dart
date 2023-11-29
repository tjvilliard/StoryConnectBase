part of 'writer_profile_bloc.dart';

@freezed
class WriterProfileState with _$WriterProfileState {
  const factory WriterProfileState({
    required String uid,
    required List<Book> books,
    required List<Announcement> announcements,
    required List<Activity> activities,
    required List<String> responseMessages,
    required bool isEditingBio,
    String? bioEditingState,
    required ProfileCardState profileCardState,
    required WritingProfileLoadingStructs loadingStructs,
  }) = _WriterProfileState;

  factory WriterProfileState.initial(String uid) => WriterProfileState(
        uid: uid,
        isEditingBio: false,
        books: [],
        announcements: [],
        responseMessages: [],
        activities: [],
        bioEditingState: null,
        loadingStructs: WritingProfileLoadingStructs.initial(),
        profileCardState: ProfileCardState.initial(uid),
      );
}

@freezed
class WritingProfileLoadingStructs with _$WritingProfileLoadingStructs {
  const factory WritingProfileLoadingStructs({
    required LoadingStruct booksLoadingStruct,
    required LoadingStruct annoucementsLoadingStruct,
    required LoadingStruct activitiesLoadingStruct,
    required LoadingStruct makeAnnouncementLoadingStruct,
  }) = _WritingProfileLoadingStructs;

  factory WritingProfileLoadingStructs.initial() => WritingProfileLoadingStructs(
        booksLoadingStruct: LoadingStruct.loading(true),
        annoucementsLoadingStruct: LoadingStruct.loading(true),
        activitiesLoadingStruct: LoadingStruct.loading(true),
        makeAnnouncementLoadingStruct: LoadingStruct.loading(false),
      );
}
