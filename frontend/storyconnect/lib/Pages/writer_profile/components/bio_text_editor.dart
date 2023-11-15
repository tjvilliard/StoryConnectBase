import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';

class BioTextEditor extends StatefulWidget {
  @override
  BioTextEditorState createState() => BioTextEditorState();
}

class BioTextEditorState extends State<BioTextEditor> {
  TextEditingController _controller = TextEditingController();

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
          child: TextField(
              onChanged: (String value) {
                context
                    .read<WriterProfileBloc>()
                    .add(EditBioStateEvent(bio: value));
              },
              maxLines: 5,
              controller: _controller,
              decoration: InputDecoration(
                  hintText: "Body",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))))),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton(
              onPressed: () {
                context.read<WriterProfileBloc>().add(CancelBioEvent());
              },
              child: Text("Cancel")),
          SizedBox(width: 10),
          FilledButton(
              onPressed: () {
                context.read<WriterProfileBloc>().add(SaveBioEvent());
              },
              child: Text("Save")),
        ],
      )
    ]);
  }
}
