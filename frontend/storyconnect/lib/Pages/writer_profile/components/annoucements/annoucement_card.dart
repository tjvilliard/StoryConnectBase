part of 'announcements.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({required this.announcement});

  // trigger popup to read entire announcement
  void _readAnnouncement(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(announcement.title),
        content: Text(announcement.content),
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
          Text(announcement.content),
          IconButton.filledTonal(
            onPressed: () => _readAnnouncement(context),
            padding: EdgeInsets.only(right: 2),
            icon: Icon(
              FontAwesomeIcons.readme,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
