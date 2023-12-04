import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/state/reading_hub_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';

class ReadingPageButton extends StatelessWidget {
  final int bookId;

  const ReadingPageButton({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          Theme.of(context).textTheme.bodySmall,
        ),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            side: const BorderSide(width: 4.0),
            borderRadius: BorderRadius.circular(10))));

    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: OutlinedButton(
            style: buttonStyle,
            onPressed: () {
              context
                  .read<ReadingHubBloc>()
                  .add(UpdateLibraryBookStatusEvent(bookId: bookId, status: 1));
              final uri = PageUrls.readBook(bookId);
              Beamer.of(context).beamToNamed(uri, data: {"book": bookId});
            },
            child: const Text("Start Reading")));
  }
}

class DetailsPageButton extends StatelessWidget {
  final int bookId;

  const DetailsPageButton({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          Theme.of(context).textTheme.bodySmall,
        ),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            side: const BorderSide(width: 4.0),
            borderRadius: BorderRadius.circular(10))));

    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: OutlinedButton(
            style: buttonStyle,
            onPressed: () {
              ReadingHubBloc bloc = context.read<ReadingHubBloc>();
              bloc.add(UpdateLibraryBookStatusEvent(bookId: bookId, status: 1));
              final uri = PageUrls.bookDetails(bookId);
              Beamer.of(context).beamToNamed(uri, data: {"book": bookId});
            },
            child: const Text("Details")));
  }
}

class MarkUnreadButton extends StatelessWidget {
  final int bookId;

  const MarkUnreadButton({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          Theme.of(context).textTheme.bodySmall,
        ),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            side: const BorderSide(width: 4.0),
            borderRadius: BorderRadius.circular(10))));

    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: OutlinedButton(
            style: buttonStyle,
            onPressed: () {
              ReadingHubBloc bloc = context.read<ReadingHubBloc>();
              bloc.add(UpdateLibraryBookStatusEvent(bookId: bookId, status: 3));
            },
            child: const Text("Mark Unread")));
  }
}

class MarkCompletedButton extends StatelessWidget {
  final int bookId;

  const MarkCompletedButton({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          Theme.of(context).textTheme.bodySmall,
        ),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            side: const BorderSide(width: 4.0),
            borderRadius: BorderRadius.circular(10))));

    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: OutlinedButton(
            style: buttonStyle,
            onPressed: () {
              ReadingHubBloc bloc = context.read<ReadingHubBloc>();
              bloc.add(UpdateLibraryBookStatusEvent(bookId: bookId, status: 2));
            },
            child: const Text("Mark Completed")));
  }
}

class RemoveBookButton extends StatelessWidget {
  final int bookId;

  const RemoveBookButton({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        textStyle:
            MaterialStatePropertyAll(Theme.of(context).textTheme.bodySmall),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            side: const BorderSide(width: 4.0),
            borderRadius: BorderRadius.circular(10))));

    return BlocBuilder<ReadingHubBloc, ReadingHubStruct>(
        builder: (BuildContext context, ReadingHubStruct state) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: OutlinedButton(
            style: buttonStyle,
            onPressed: () {
              ReadingHubBloc bloc = context.read<ReadingHubBloc>();
              bloc.add(RemoveLibraryBookEvent(bookId: bookId));
            },
            child: const Text("Remove")),
      );
    });
  }
}
