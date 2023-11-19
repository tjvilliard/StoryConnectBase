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
class GenericResponse with _$GenericResponse {
  const factory GenericResponse({
    required bool success,
    String? message,
  }) = _GenericResponse;

  factory GenericResponse.fromJson(Map<String, dynamic> json) => _$GenericResponseFromJson(json);
}

@freezed
class Library with _$Library {
  const factory Library({
    required int id,
    int? book,
    required int status,
    int? reader,
  }) = _Library;

  factory Library.fromJson(Map<String, dynamic> json) => _$LibraryFromJson(json);
}

@freezed
class LibraryBook with _$LibraryBook {
  const factory LibraryBook({
    required int id,
    int? bookId,
    required int status,
    required Book book,
    int? reader,
  }) = _LibraryBook;

  factory LibraryBook.fromJson(Map<String, dynamic> json) => _$LibraryBookFromJson(json);
}

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required int id,
    required int book,
    @JsonKey(name: 'chapter_title') required String chapterTitle,
    @JsonKey(name: 'content') required String chapterContent,
    @JsonKey(name: 'chapter_number') required int number,
    @JsonKey(name: 'raw_content') required String rawContent,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);
}

@freezed
class ChapterUpload with _$ChapterUpload {
  const factory ChapterUpload({
    required int book,
    @JsonKey(name: 'chapter_title') required String chapterTitle,
    @JsonKey(name: 'content') required String chapterContent,
    @JsonKey(name: 'chapter_number') required int number,
  }) = _ChapterUpload;

  factory ChapterUpload.fromJson(Map<String, dynamic> json) => _$ChapterUploadFromJson(json);
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

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
}

@freezed
class Location with _$Location {
  const factory Location({
    required int id,
    required int book,
    required String name,
    String? description,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
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

  factory Annotation.fromJson(Map<String, dynamic> json) => _$AnnotationFromJson(json);
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

  factory Highlight.fromJson(Map<String, dynamic> json) => _$HighlightFromJson(json);
}

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String bio,
    @JsonKey(name: 'display_name') required String displayName,
    int? id,
    int? user,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  factory Profile.initial() => Profile(
        id: 0,
        bio: '',
        user: 0,
        displayName: '',
        imageUrl: '',
      );
}
