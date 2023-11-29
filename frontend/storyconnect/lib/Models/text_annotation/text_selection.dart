import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_selection.freezed.dart';
part 'text_selection.g.dart';

@freezed
class AnnotatedTextSelection with _$AnnotatedTextSelection {
  const factory AnnotatedTextSelection({
    required int offset,
    required int offsetEnd,
    @JsonKey(name: 'chapter') required int chapterId,
    String? text,
    required bool floating,
  }) = _AnnotatedTextSelection;

  const AnnotatedTextSelection._();

  factory AnnotatedTextSelection.fromJson(Map<String, dynamic> json) =>
      _$AnnotatedTextSelectionFromJson(json);
}
