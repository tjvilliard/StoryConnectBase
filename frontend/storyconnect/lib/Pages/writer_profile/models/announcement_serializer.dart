part of 'writer_profile_models.dart';

@freezed
class AnnouncementSerializer with _$AnnouncementSerializer {
  const factory AnnouncementSerializer({
    required String title,
    required String content,
    int? id,
    @JsonKey(name: 'user') int? userId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AnnouncementSerializer;

  factory AnnouncementSerializer.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementSerializerFromJson(json);
}
