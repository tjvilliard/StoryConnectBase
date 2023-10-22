import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_entry_serializer.freezed.dart';
part 'library_entry_serializer.g.dart';

@freezed
class LibraryEntrySerialzier with _$LibraryEntrySerialzier {
  const factory LibraryEntrySerialzier({
    required int book,
    required int status,
    required int reader,
  }) = _LibraryEntrySerialzier;
  const LibraryEntrySerialzier._();
  factory LibraryEntrySerialzier.fromJson(Map<String, dynamic> json) =>
      _$LibraryEntrySerialzierFromJson(json);

  factory LibraryEntrySerialzier.initial(int bookId) {
    return LibraryEntrySerialzier(
      book: bookId,
      status: 1,
      reader: 6,
    );
  }

  bool verify() {
    return true;
  }
}
