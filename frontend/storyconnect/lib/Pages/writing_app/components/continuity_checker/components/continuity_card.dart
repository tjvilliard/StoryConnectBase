import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/models/continuity_models.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/state/continuity_bloc.dart';

class ContinuityCard extends StatelessWidget {
  final ContinuitySuggestion continuity;

  const ContinuityCard({Key? key, required this.continuity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minHeight: 150),
        child: Card(
            margin: EdgeInsets.all(5),
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(
                              //     "Type: ${continuity.suggestionType ?? "Unknown"}",
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .titleSmall!
                              //         .apply(fontStyle: FontStyle.italic)),
                            ]),
                      ),
                      Container(
                        alignment: Alignment.center,
                        constraints:
                            BoxConstraints(minHeight: 10, maxHeight: 100),
                        child: Text(continuity.content,
                            style: Theme.of(context).textTheme.titleSmall),
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: FilledButton.tonalIcon(
                              onPressed: () {
                                BlocProvider.of<ContinuityBloc>(context).add(
                                    DismissContinuityEvent(continuity.uuid));
                              },
                              icon: Icon(Icons.close),
                              label: Text("Dismiss",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium))),
                    ]))));
  }
}

class NavigateToContinuityButton {}


// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:storyconnect/Models/text_annotation/feedback.dart';
// // import 'package:storyconnect/Models/text_annotation/feedback.dart';
// import 'package:storyconnect/Pages/writing_app/components/feedback/components/navigate_button.dart';

// class CommentWidget extends StatelessWidget {
//   final WriterFeedback comment;

//   CommentWidget({required this.comment});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         constraints: BoxConstraints(minHeight: 150),
//         child: Card(
//             margin: EdgeInsets.all(5),
//             elevation: 5,
//             child: Padding(
//                 padding: EdgeInsets.all(10),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Align(
//                       alignment: Alignment.topCenter,
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Chapter ${comment.chapterId}",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleSmall!
//                                     .apply(fontStyle: FontStyle.italic)),
//                             if (comment.isGhost == false)
//                               NavigateToFeedbackButton(
//                                 feedback: comment,
//                               )
//                           ]),
//                     ),
//                     Container(
//                       alignment: Alignment.center,
//                       constraints:
//                           BoxConstraints(minHeight: 10, maxHeight: 100),
//                       child: Text(comment.sentiment.description,
//                           style: Theme.of(context).textTheme.titleSmall),
//                     ),
//                     Align(
//                         alignment: Alignment.bottomRight,
//                         child: FilledButton.tonalIcon(
//                             onPressed: () {},
//                             icon: Icon(FontAwesomeIcons.x),
//                             label: Text("Dismiss",
//                                 style:
//                                     Theme.of(context).textTheme.labelMedium))),
//                   ],
//                 ))));
//   }
// }


