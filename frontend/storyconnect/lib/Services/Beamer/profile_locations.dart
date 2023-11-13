import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';
import 'package:storyconnect/Pages/writer_profile/view.dart';
import 'package:storyconnect/Repositories/profile_repository.dart';

import 'package:storyconnect/Services/Beamer/custom_beam_page.dart';

class ProfileLocations extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        '/profile',
        '/profile/writer/:userId',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <CustomBeamPage>[];
    final url = state.uri.pathSegments;

    if (url.contains('writer')) {
      final String? userId = state.pathParameters['userId'];
      pages.add(CustomBeamPage(
          key: ValueKey('writer-$userId'),
          child: BlocProvider(
            create: (context) =>
                WriterProfileBloc(context.read<ProfileRepository>()),
            child: WriterProfileWidget(uid: userId!),
          )));
    } else {
      pages.add(CustomBeamPage(
          key: ValueKey('profile'),
          child: Center(
            child: Text("No user exists",
                style: Theme.of(context).textTheme.displayMedium),
          )));
    }

    return pages;
  }
}
