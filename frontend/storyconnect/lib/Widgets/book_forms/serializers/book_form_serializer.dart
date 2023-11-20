import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/language_constants.dart';

part 'book_form_serializer.freezed.dart';
part 'book_form_serializer.g.dart';

@freezed
class BookFormSerializer with _$BookFormSerializer {
  const factory BookFormSerializer({
    required String title,
    required String? language,
    @JsonKey(name: 'target_audience') int? targetAudience,
    String? synopsis,
    int? copyright,
    String? cover,
  }) = _BookFormSerializer;
  const BookFormSerializer._();
  factory BookFormSerializer.fromJson(Map<String, dynamic> json) => _$BookFormSerializerFromJson(json);

  // initial constructor
  factory BookFormSerializer.initial() {
    return BookFormSerializer(
        title: "",
        // author: "",
        language: LanguageConstant.english.label,
        synopsis: "",
        cover: "",
        copyright: CopyrightOption.allRightsReserved.index);
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
    // Synopsis can be an empty String, but it shouldn't be null.
    if (synopsis == null) {
      return false;
    }
    if (copyright == null) {
      return false;
    }
    return true;
  }
}
