import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';

class BioTextEditor extends StatefulWidget {
  const BioTextEditor({super.key});

  @override
  BioTextEditorState createState() => BioTextEditorState();
}

class BioTextEditorState extends State<BioTextEditor> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<WriterProfileBloc>();
      _controller.text = bloc.state.bioEditingState ?? bloc.state.profile.bio;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                  onChanged: (String value) {
                    context.read<WriterProfileBloc>().add(EditBioStateEvent(bio: value));
                  },
                  maxLines: 4,
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: "Body", border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)))))),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton.tonal(
              onPressed: () {
                context.read<WriterProfileBloc>().add(const CancelProfileEditEvent());
              },
              child: const Text("Cancel")),
          const SizedBox(width: 10),
          FilledButton.icon(
              onPressed: () {
                context.read<WriterProfileBloc>().add(const SaveProfileEvent());
              },
              icon: const Icon(Icons.save),
              label: const Text("Save")),
        ],
      )
    ]);
  }
}
