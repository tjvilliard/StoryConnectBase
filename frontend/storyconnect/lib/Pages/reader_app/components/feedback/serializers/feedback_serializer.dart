import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Constants/feedback_sentiment.dart';
import 'package:storyconnect/Models/text_annotation/text_selection.dart';

part 'feedback_serializer.freezed.dart';
part 'feedback_serializer.g.dart';

@freezed
class FeedbackCreationSerializer with _$FeedbackCreationSerializer {
  const factory FeedbackCreationSerializer({
    required AnnotatedTextSelection selection,
    String? comment,
    @JsonKey(name: 'parent') int? parentId,
    required int sentiment,
    required bool dismissed,
    required bool isSuggestion,
  }) = _FeedbackCreationSerializer;

  ///
  bool get isGhost => selection.floating;

  ///
  int get chapterId => selection.chapterId;

  const FeedbackCreationSerializer._();
  factory FeedbackCreationSerializer.fromJson(Map<String, dynamic> json) =>
      _$FeedbackCreationSerializerFromJson(json);

  factory FeedbackCreationSerializer.initial() {
    return FeedbackCreationSerializer(
      selection: const AnnotatedTextSelection(
          chapterId: 0, floating: false, offsetEnd: 0, offset: 0, text: ""),
      sentiment: FeedbackSentiment.good.index,
      isSuggestion: true,
      dismissed: false,
      comment: "",
      parentId: null,
    );
  }

  /// Verifies the state of this Feedback is good.
  bool verify() {
    return true;
  }
}
