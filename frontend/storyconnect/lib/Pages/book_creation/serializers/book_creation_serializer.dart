import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Constants/language_constants.dart';

part 'book_creation_serializer.freezed.dart';
part 'book_creation_serializer.g.dart';

@freezed
class BookCreationSerializer with _$BookCreationSerializer {
  const factory BookCreationSerializer({
    required String title,
    required String author,
    required String? language,
    int? targetAudience,
    int? copyright,
  }) = _BookCreationSerializer;

  factory BookCreationSerializer.fromJson(Map<String, dynamic> json) =>
      _$BookCreationSerializerFromJson(json);

  // initial constructor
  factory BookCreationSerializer.initial() {
    return BookCreationSerializer(
      title: "",
      author: "",
      language: LanguageConstant.english.label,
    );
  }
}
