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
  late final bool focusWhenBuilt;
  bool shouldNav = false;
  bool firstNav = true;

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

  void scrollToSelf(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      node.requestFocus();
      await Scrollable.ensureVisible(node.context!,
          duration: Duration(milliseconds: 250),
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd);
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PageBloc, PageBlocStruct>(
        listenWhen: (previous, current) {
      return current.navigateToIndex == index && node.context != null;
    }, listener: (context, state) async {
      shouldNav = true;
    }, buildWhen: (previousStruct, currentStruct) {
      final bool rebuild = controller.text != currentStruct.pages[index];
      if (rebuild) {
        controller.text = currentStruct.pages[index] ?? "";
      }
      return rebuild;
    }, builder: (context, state) {
      if (shouldNav) {
        scrollToSelf(context);
        shouldNav = false;
      } else if (firstNav) {
        scrollToSelf(context);
        firstNav = false;
      }

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
