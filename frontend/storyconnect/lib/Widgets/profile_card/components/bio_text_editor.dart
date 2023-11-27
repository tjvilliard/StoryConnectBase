import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Widgets/profile_card/state/profile_card_bloc.dart';

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
      final bloc = context.read<ProfileCardBloc>();
      _controller.text = bloc.state.isEditing ? bloc.state.profile.bio : "";
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
                    context.read<ProfileCardBloc>().add(EditBioStateEvent(bio: value));
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
                context.read<ProfileCardBloc>().add(const CancelProfileEditEvent());
              },
              child: const Text("Cancel")),
          const SizedBox(width: 10),
          FilledButton.icon(
              onPressed: () {
                context.read<ProfileCardBloc>().add(const SaveProfileEvent());
              },
              icon: const Icon(Icons.save),
              label: const Text("Save")),
        ],
      )
    ]);
  }
}
