import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'models.freezed.dart';
part 'models.g.dart';

String localUuidFromJson(String json) {
  return Uuid().v8();
}

@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class Book with _$Book {
  const factory Book({
    required int id,
    required String title,
    String? author,
    int? owner,
    String? language,
    @JsonKey(name: 'target_audience') int? targetAudience,
    String? cover,
    @JsonKey(name: 'created') required DateTime created,
    @JsonKey(name: 'modified') required DateTime modified,
    String? synopsis,
    int? copyright,
    String? titlepage,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}

@freezed
class Library with _$Library {
  const factory Library({
    required int id,
    required int book,
    required int status,
    required int reader,
  }) = _Library;

  factory Library.fromJson(Map<String, dynamic> json) =>
      _$LibraryFromJson(json);
}

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required int id,
    required int book,
    @JsonKey(name: 'chapter_title') required String chapterTitle,
    @JsonKey(name: 'content') required String chapterContent,
    @JsonKey(name: 'chapter_number') required int number,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}

@freezed
class ChapterUpload with _$ChapterUpload {
  const factory ChapterUpload({
    required int book,
    @JsonKey(name: 'chapter_title') required String chapterTitle,
    @JsonKey(name: 'content') required String chapterContent,
    @JsonKey(name: 'chapter_number') required int number,
  }) = _ChapterUpload;

  factory ChapterUpload.fromJson(Map<String, dynamic> json) =>
      _$ChapterUploadFromJson(json);
}

@freezed
class Character with _$Character {
  const factory Character({
    required int id,
    required int book,
    required String name,
    String? nickname,
    String? bio,
    String? description,
    String? image,
    String? attributes,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
}

@freezed
class Location with _$Location {
  const factory Location({
    required int id,
    required int book,
    required String name,
    String? description,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@freezed
class Scene with _$Scene {
  const factory Scene({
    required int id,
    required int chapter,
    @JsonKey(name: 'scene_title') String? sceneTitle,
    @JsonKey(name: 'scene_content') String? sceneContent,
  }) = _Scene;

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);
}

@freezed
class Annotation with _$Annotation {
  const factory Annotation({
    required int id,
    int? commentId,
  }) = _Annotation;

  factory Annotation.fromJson(Map<String, dynamic> json) =>
      _$AnnotationFromJson(json);
}

@freezed
class Highlight with _$Highlight {
  const factory Highlight({
    required int id,
    @JsonKey(name: 'user_display_name') int? userDisplayName,
    @JsonKey(name: 'chapter_id') int? chapterId,
    @JsonKey(name: 'chapter_offset') int? chapterOffset,
    int? length,
    String? text,
    String? color,
  }) = _Highlight;

  factory Highlight.fromJson(Map<String, dynamic> json) =>
      _$HighlightFromJson(json);
}

@freezed
class RoadUnblockerRequest with _$RoadUnblockerRequest {
  const factory RoadUnblockerRequest({
    required String chapter,
    required String selection,
    required String question,
  }) = _RoadUnblockerRequest;
  const RoadUnblockerRequest._();

  factory RoadUnblockerRequest.fromJson(Map<String, dynamic> json) =>
      _$RoadUnblockerRequestFromJson(json);
}

@freezed
class RoadUnblockerSuggestion with _$RoadUnblockerSuggestion {
  factory RoadUnblockerSuggestion({
    // This field stores a locally generated UUID and is not serialized to JSON
    @JsonKey(fromJson: localUuidFromJson, includeToJson: false)
    required String localId, // <- Local only UUID
    @JsonKey(name: 'offset_start') required int offsetStart,
    @JsonKey(name: 'offset_end') required int offsetEnd,
    required String suggestion,
    String? original,
    @JsonKey(name: 'suggested_change') required String suggestedChange,
  }) = _RoadUnblockerSuggestion;
  const RoadUnblockerSuggestion._();

  bool isAddition() {
    return original == null || original!.isEmpty;
  }

  factory RoadUnblockerSuggestion.fromJson(Map<String, dynamic> json) =>
      _$RoadUnblockerSuggestionFromJson(json);
}

@freezed
class RoadUnblockerResponse with _$RoadUnblockerResponse {
  factory RoadUnblockerResponse({
    @JsonKey(fromJson: localUuidFromJson, includeToJson: false)
    required String localId, // <- Local only UUID
    required String message,
    required List<RoadUnblockerSuggestion> suggestions,
  }) = _RoadUnblockerResponse;
  const RoadUnblockerResponse._();

  factory RoadUnblockerResponse.fromJson(Map<String, dynamic> json) =>
      _$RoadUnblockerResponseFromJson(json);
}
