part of 'announcement_card.dart';

class _Announcement extends StatelessWidget {
  final String announcement;

  const _Announcement({required this.announcement});

  // trigger popup to read entire announcement
  void _readAnnouncement(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Announcement"),
        content: Text(announcement),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          )
        ],
      ),
    );
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(announcement),
          IconButton(
            onPressed: () => _readAnnouncement(context),
            icon: Icon(FontAwesomeIcons.readme),
          )
        ],
      ),
    );
  }
}
