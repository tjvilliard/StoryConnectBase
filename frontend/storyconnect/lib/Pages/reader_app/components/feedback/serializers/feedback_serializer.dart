import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Constants/feedback_sentiment.dart';

part 'feedback_serializer.freezed.dart';
part 'feedback_serializer.g.dart';

@freezed
class FeedbackCreationSerializer with _$FeedbackCreationSerializer {
  const factory FeedbackCreationSerializer({
    required int chapterId,
    @JsonKey(name: 'sentiment') int? sentiment,
    required bool isSuggestion,
    required bool dismissed,
    String? comment,
    int? parentId,
    String? suggestion,
  }) = _FeedbackCreationSerializer;

  const FeedbackCreationSerializer._();
  factory FeedbackCreationSerializer.fromJson(Map<String, dynamic> json) =>
      _$FeedbackCreationSerializerFromJson(json);

  factory FeedbackCreationSerializer.initial() {
    return FeedbackCreationSerializer(
      chapterId: 0,
      sentiment: FeedbackSentiment.good.index,
      isSuggestion: false,
      dismissed: false,
      comment: "",
      parentId: null,
      suggestion: "",
    );
  }

  /// Verifies the state of this Feedback is good.
  bool verify() {
    if (sentiment == null) {
      return false;
    }

    return true;
  }
}
