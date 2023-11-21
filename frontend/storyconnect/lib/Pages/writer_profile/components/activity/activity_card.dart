part of 'recent_activity_card.dart';

class _ActivityCard extends StatelessWidget {
  final Activity activity;

  const _ActivityCard({required this.activity});

  static String _constructSentence(Activity activity) {
    String activityString =
        "${activity.subject} ${activity.action} ${activity.preposition} ${activity.object}";
    // remove double spaces with single space, and trim
    return activityString.replaceAll(RegExp(r"\s+"), " ").trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(_constructSentence(activity)),
    );
  }
}
