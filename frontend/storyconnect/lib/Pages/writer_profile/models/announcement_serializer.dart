part of 'writer_profile_models.dart';

@freezed
class AnnouncementSerializer with _$AnnouncementSerializer {
  const factory AnnouncementSerializer({
    required String title,
    required String content,
  }) = _AnnouncementSerializer;

  factory AnnouncementSerializer.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementSerializerFromJson(json);
}
