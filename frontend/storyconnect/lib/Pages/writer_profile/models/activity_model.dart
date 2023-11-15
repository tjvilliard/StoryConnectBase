part of 'writer_profile_models.dart';

@freezed
class Activity with _$Activity {
  const factory Activity({
    required int id,
    required String subject,
    required String object,
    required String action,
    required String preposition,
    required DateTime time,
  }) = _Activity;

  factory Activity.initial() => Activity(
        id: 0,
        subject: "",
        action: "",
        object: "",
        preposition: "",
        time: DateTime.now(),
      );

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
