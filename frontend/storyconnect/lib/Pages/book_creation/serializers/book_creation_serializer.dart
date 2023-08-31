import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Constants/language_constants.dart';

part 'book_creation_serializer.freezed.dart';
part 'book_creation_serializer.g.dart';

@freezed
class BookCreationSerializer with _$BookCreationSerializer {
  const factory BookCreationSerializer({
    required String title,
    // required String author,
    required String? language,
    @JsonKey(name: 'target_audience') int? targetAudience,
    // int? copyright,
  }) = _BookCreationSerializer;
  const BookCreationSerializer._();
  factory BookCreationSerializer.fromJson(Map<String, dynamic> json) =>
      _$BookCreationSerializerFromJson(json);

  // initial constructor
  factory BookCreationSerializer.initial() {
    return BookCreationSerializer(
      title: "",
      // author: "",
      language: LanguageConstant.english.label,
    );
  }

  bool verify() {
    if (title.isEmpty) {
      return false;
    }
    // if (author.isEmpty) {
    //   return false;
    // }
    if (language == null) {
      return false;
    }
    if (targetAudience == null) {
      return false;
    }
    return true;
  }
}
