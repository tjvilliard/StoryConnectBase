part of 'writer_profile_models.dart';

@freezed
class Announcement with _$Announcement {
  const factory Announcement({
    int? id,
    required String title,
    required String content,
    @JsonKey(name: 'user') int? userId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Announcement;

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
}