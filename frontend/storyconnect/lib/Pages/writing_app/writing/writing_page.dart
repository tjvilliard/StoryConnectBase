import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/paging_logic.dart';

class WritingPageView extends StatefulWidget {
  final int index;
  const WritingPageView({super.key, required this.index});

  @override
  State<WritingPageView> createState() => WritingPageViewState();
}

class WritingPageViewState extends State<WritingPageView> {
  late final TextEditingController controller;
  late final int index;
  late final FocusNode node;
  late final PagingLogic pagingLogic;
  @override
  void initState() {
    controller = TextEditingController();
    index = widget.index;
    node = FocusNode();
    pagingLogic = PagingLogic();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (mounted) {
      controller.text =
          BlocProvider.of<PageBloc>(context).state.pages[index] ?? "";
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageBloc, PageBlocStruct>(
        buildWhen: (previous, current) {
      final bool rebuild = controller.text != current.pages[index];
      if (rebuild) {
        controller.text = current.pages[index] ?? "";
      }
      return rebuild;
    }, builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(width: .5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          child: TextField(
            focusNode: node,
            onChanged: (value) {
              final results = pagingLogic.shouldTriggerOverflow(
                  value, TextStyle(fontSize: 20));

              if (results.didOverflow) {
                controller.text = results.textToKeep;

                node.unfocus();
                context.read<PageBloc>().add(
                    AddPage(text: results.overflowText, callerIndex: index));
                context.read<PageBloc>().add(
                    UpdatePage(text: results.textToKeep, callerIndex: index));
              } else {
                context
                    .read<PageBloc>()
                    .add(UpdatePage(text: controller.text, callerIndex: index));
              }
              if (controller.text.isEmpty && index != 0) {
                context.read<PageBloc>().add(RemovePage(callerIndex: index));
              }
            },
            controller: controller,
            maxLines: null,
            decoration: InputDecoration(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: 'Begin Writing...'),
          ));
    });
  }
}
