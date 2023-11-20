import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';

class DisplayNameEditor extends StatefulWidget {
  const DisplayNameEditor({super.key});

  @override
  _DisplayNameEditorState createState() => _DisplayNameEditorState();
}

class _DisplayNameEditorState extends State<DisplayNameEditor> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<WriterProfileBloc>();
      _controller.text = bloc.state.profile.displayName;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WriterProfileBloc, WriterProfileState>(builder: (context, state) {
      return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 200,
          ),
          child: TextField(
            controller: _controller,
            onChanged: (String value) {
              context.read<WriterProfileBloc>().add(EditDisplayNameEvent(displayName: value));
            },
            decoration: InputDecoration(
              labelText: "Display Name",
            ),
          ));
    });
  }
}
