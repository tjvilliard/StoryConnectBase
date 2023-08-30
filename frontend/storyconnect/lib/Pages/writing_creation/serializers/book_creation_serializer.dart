import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_creation_serializer.freezed.dart';
part 'book_creation_serializer.g.dart';

@freezed
class BookCreationSerializer with _$BookCreationSerializer {
  const factory BookCreationSerializer({
    required String title,
    String? author,
    String? cover, // base 64
    String? synopsis,
    int? copyRight,
    String? titlePage,
  }) = _BookCreationSerializer;

  factory BookCreationSerializer.fromJson(Map<String, dynamic> json) =>
      _$BookCreationSerializerFromJson(json);

  // initial constructor
  factory BookCreationSerializer.initial() {
    return BookCreationSerializer(
      title: "",
    );
  }
}
