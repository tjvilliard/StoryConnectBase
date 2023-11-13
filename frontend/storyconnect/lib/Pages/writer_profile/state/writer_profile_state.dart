part of 'writer_profile_bloc.dart';

@freezed
class WriterProfileState with _$WriterProfileState {
  const factory WriterProfileState({
    required Profile profile,
    required List<Book> books,
    required List<Announcement> announcements,
    required List<Activity> activities,
    required List<String> responseMessages,
    required LoadingStruct annoucementsLoadingStruct,
    required LoadingStruct booksLoadingStruct,
    required LoadingStruct profileLoadingStruct,
    required LoadingStruct makeAnnouncementLoadingStruct,
    required LoadingStruct activitiesLoadingStruct,
  }) = _WriterProfileState;

  factory WriterProfileState.initial() => WriterProfileState(
        profile: Profile.initial(),
        books: [],
        announcements: [],
        responseMessages: [],
        activities: [],
        annoucementsLoadingStruct: LoadingStruct.loading(true),
        booksLoadingStruct: LoadingStruct.loading(true),
        profileLoadingStruct: LoadingStruct.loading(true),
        activitiesLoadingStruct: LoadingStruct.loading(true),
        makeAnnouncementLoadingStruct: LoadingStruct.loading(false),
      );
}
