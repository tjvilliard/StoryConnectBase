import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_entry_serializer.freezed.dart';
part 'library_entry_serializer.g.dart';

@freezed
class LibraryEntrySerializer with _$LibraryEntrySerializer {
  const factory LibraryEntrySerializer({
    int? id,
    int? reader,
    required int book,
    required int status,
  }) = _LibraryEntrySerializer;
  const LibraryEntrySerializer._();
  factory LibraryEntrySerializer.fromJson(Map<String, dynamic> json) =>
      _$LibraryEntrySerializerFromJson(json);

  factory LibraryEntrySerializer.initial(int bookId) {
    return LibraryEntrySerializer(
      book: bookId,
      status: 1,
    );
  }

  bool verify() {
    return true;
  }
}
