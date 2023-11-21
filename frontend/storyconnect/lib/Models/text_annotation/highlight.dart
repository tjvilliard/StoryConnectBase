import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/text_annotation/text_selection.dart';

part 'highlight.freezed.dart';
part 'highlight.g.dart';

@freezed
class Highlight with _$Highlight {
  const factory Highlight({
    required int id,
    required int user,
    required int chapterId,
    required AnnotatedTextSelection selection,
    required String color,
    String? text,
  }) = _Highlight;

  const Highlight._();

  factory Highlight.fromJson(Map<String, dynamic> json) =>
      _$HighlightFromJson(json);

  bool get isGhost => selection.floating;

  bool get isAnnotation => text != null;
}
