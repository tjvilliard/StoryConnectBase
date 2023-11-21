part of 'announcements.dart';

class _MakeAnnouncementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WriterProfileBloc, WriterProfileState>(
        buildWhen: (previous, current) =>
            previous.announcements != current.announcements,
        builder: (context, state) {
          return FilledButton(
              onPressed: () {
                final WriterProfileBloc bloc =
                    context.read<WriterProfileBloc>();
                showDialog(
                    context: context,
                    builder: (context) {
                      return _MakeAnnoucementDialog(
                        bloc: bloc,
                      );
                    });
              },
              child: const Text("Make Announcement"));
        });
  }
}
