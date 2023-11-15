part of 'announcements.dart';

class _MakeAnnoucementDialog extends StatefulWidget {
  final WriterProfileBloc bloc;
  const _MakeAnnoucementDialog({required this.bloc});

  @override
  _MakeAnnoucementDialogState createState() => _MakeAnnoucementDialogState();
}

class _MakeAnnoucementDialogState extends State<_MakeAnnoucementDialog> {
  final titleEditingController = TextEditingController();
  final bodyEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      constraints: BoxConstraints(maxWidth: 450, minHeight: 500),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Make Announcement",
              style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 20),
          TextField(
            controller: titleEditingController,
            decoration: InputDecoration(
                hintText: "Title",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 10),
          Flexible(
              child: TextField(
            maxLines: 10,
            controller: bodyEditingController,
            decoration: InputDecoration(
                hintText: "Body",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          )),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.bloc.add(MakeAnnouncementEvent(
                      title: titleEditingController.text,
                      content: bodyEditingController.text));
                },
                child: Text("Make"),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
