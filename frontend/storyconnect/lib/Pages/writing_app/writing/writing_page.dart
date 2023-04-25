import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/paging_logic.dart';

typedef void ScrollToIndexCallback(PageBlocStruct state);

class WritingPageView extends StatefulWidget {
  final int index;
  const WritingPageView({super.key, required this.index});

  @override
  State<WritingPageView> createState() => WritingPageViewState();
}

class WritingPageViewState extends State<WritingPageView>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController controller;
  late final int index;
  late final FocusNode node;
  late final PagingLogic pagingLogic;
  late final bool focusWhenBuilt;
  final _textFieldKey = GlobalKey();
  int cursorPosition = 0;
  bool shouldNav = false;
  bool firstNav = false;

  @override
  void initState() {
    controller = TextEditingController();
    index = widget.index;
    node = FocusNode();
    pagingLogic = PagingLogic();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        final result = context.read<PageBloc>().state.pagesCreated[index];
        assert(result != null);
        if (result == true) {
          setState(() {
            firstNav = true;
          });
        }
      }
    });

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

  Offset getCursorPosition(BuildContext context, TextSelection caretPosition) {
    final RenderObject? textFieldRenderObject =
        _textFieldKey.currentContext?.findRenderObject();
    if (textFieldRenderObject == null) {
      return Offset.zero;
    }
    final RenderBox textFieldRenderBox = textFieldRenderObject as RenderBox;
    final textBeforeCaret =
        controller.text.substring(0, caretPosition.baseOffset);
    final textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(text: textBeforeCaret, style: TextStyle(fontSize: 14))
      ..layout();

    final caretPrototype = Rect.fromLTWH(0, 0, 1, 1);
    final caretOffset = textPainter.getOffsetForCaret(
        TextPosition(offset: controller.text.length), caretPrototype);
    final localPosition = textFieldRenderBox.localToGlobal(caretOffset,
        ancestor: context.findRenderObject());

    return localPosition;
  }

  @override
  Widget build(BuildContext parentContext) {
    super.build(context);
    return BlocBuilder<PageBloc, PageBlocStruct>(
        buildWhen: (previousStruct, currentStruct) {
      final bool rebuild = controller.text != currentStruct.pages[index];
      if (rebuild) {
        controller.text = currentStruct.pages[index] ?? "";
      }
      return rebuild;
    }, builder: (context, state) {
      if (node.hasFocus) {
        try {
          final pos = controller.selection =
              TextSelection.fromPosition(TextPosition(offset: cursorPosition));
          controller.selection = pos;
        } catch (e) {
          print(e);
        }
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
            scrollPhysics: NeverScrollableScrollPhysics(),
            key: _textFieldKey,
            focusNode: node,
            onChanged: (value) {
              final chapterBloc = context.read<ChapterBloc>();
              final results = pagingLogic.shouldTriggerOverflow(
                  value, TextStyle(fontSize: 20));
              cursorPosition = controller.selection.baseOffset;

              if (results.didOverflow) {
                controller.text = results.textToKeep;
                bool shouldJump = false;

                if (cursorPosition >= controller.text.length) {
                  shouldJump = true;
                  node.unfocus();
                }
                context.read<PageBloc>().add(UpdatePage(
                    text: results.textToKeep,
                    callerIndex: index,
                    shouldJump: shouldJump,
                    chapterBloc: chapterBloc));
                context.read<PageBloc>().add(AddPage(
                    text: results.overflowText,
                    callerIndex: index,
                    shouldJump: shouldJump));
              } else if (controller.text.isEmpty && index != 0) {
                context.read<PageBloc>().add(RemovePage(callerIndex: index));
              } else {
                context.read<PageBloc>().add(UpdatePage(
                    text: controller.text,
                    callerIndex: index,
                    shouldJump: false,
                    chapterBloc: chapterBloc));
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

  @override
  bool get wantKeepAlive => true;
}
