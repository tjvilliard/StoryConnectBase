import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

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
    required String author,
    required int owner,
    required String language,
    @JsonKey(name: 'target_audience') required int targetAudience,
    String? cover,
    @JsonKey(name: 'date_created') required DateTime dateCreated,
    @JsonKey(name: 'date_modified') required DateTime dateModified,
    required String synopsis,
    required int copyright,
    required String titlepage,
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
    @JsonKey(name: 'chapter_content') required String chapterContent,
    @JsonKey(name: 'number') required int number,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
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
