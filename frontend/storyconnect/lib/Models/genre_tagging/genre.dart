import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre.freezed.dart';
part 'genre.g.dart';

@freezed
class GenreTags with _$GenreTags {
  const factory GenreTags({
    @JsonKey(name: "genre") required List<String> tags,
  }) = _GenreTags;

  factory GenreTags.fromJson(Map<String, dynamic> json) =>
      _$GenreTagsFromJson(json);
}
