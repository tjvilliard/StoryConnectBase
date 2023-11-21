import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Constants/feedback_sentiment.dart';
import 'package:storyconnect/Models/text_annotation/text_selection.dart';

part 'feedback.freezed.dart';
part 'feedback.g.dart';

@freezed
class WriterFeedback with _$WriterFeedback {
  const factory WriterFeedback({
    required int id, // ID of the comment
    required int userId, //ID of the user in the db.
    required int chapterId, //not chapter index, but the actual chapter ID
    required AnnotatedTextSelection selection,
    required FeedbackSentiment sentiment,
    required bool isSuggestion,
    required bool dismissed,
    String? comment,
    int? parentId,
    DateTime? posted,
    DateTime? edited,
    String? suggestion,
  }) = _WriterFeedback;

  const WriterFeedback._();

  bool get isGhost => selection.floating;
  @override
  int get chapterId => selection.chapterId;

  factory WriterFeedback.fromJson(Map<String, dynamic> json) => _$WriterFeedbackFromJson(json);
}
