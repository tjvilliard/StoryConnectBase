part of 'writer_profile_bloc.dart';

@freezed
class WriterProfileState with _$WriterProfileState {
  const factory WriterProfileState({
    required String name,
    required String bio,
    required String avatar,
  }) = _WriterProfileState;

  factory WriterProfileState.initial() => const WriterProfileState(
        name: '',
        bio: '',
        avatar: '',
      );
}
