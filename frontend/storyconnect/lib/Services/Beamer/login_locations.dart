import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/about_team/view.dart';
import 'package:storyconnect/Pages/login/state/login_bloc.dart';
import 'package:storyconnect/Pages/login/view.dart';
import 'package:storyconnect/Pages/registration/state/register_bloc.dart';
import 'package:storyconnect/Pages/registration/view.dart';
import 'package:storyconnect/Repositories/core_repository.dart';
import 'package:storyconnect/Repositories/firebase_repository.dart';
import 'package:storyconnect/Services/Beamer/custom_beam_page.dart';
import 'package:storyconnect/Services/url_service.dart';

class LoginLocations extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        '/',
        '/register',
        '/recover',
        PageUrls.login,
        PageUrls.about,
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> pages = <CustomBeamPage>[];
    final url = state.uri.pathSegments;
    final String aboutUrl = PageUrls.getLastPathSegment(PageUrls.about);
    final String loginUrl = PageUrls.getLastPathSegment(PageUrls.login);

    if (url.isEmpty || url.contains(loginUrl)) {
      pages.add(CustomBeamPage(
          key: const ValueKey('login'),
          child: RepositoryProvider<FirebaseRepository>(
            create: (_) => FirebaseRepository(),
            child: BlocProvider<LoginBloc>(
              create: (context) =>
                  LoginBloc(context.read<FirebaseRepository>()),
              child: const LoginPageView(),
            ),
          )));
    } else if (url.contains('register')) {
      pages.add(CustomBeamPage(
          key: const ValueKey('register'),
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<FirebaseRepository>(
                  create: (_) => FirebaseRepository()),
              RepositoryProvider<CoreRepository>(
                  create: (_) => CoreRepository()),
            ],
            child: BlocProvider<RegistrationBloc>(
              create: (context) => RegistrationBloc(
                  context.read<FirebaseRepository>(),
                  context.read<CoreRepository>()),
              child: const RegistrationPageView(),
            ),
          )));
    } else if (url.contains('recover')) {
      //pages.add();
    } else if (url.contains(aboutUrl)) {
      pages.add(const CustomBeamPage(
        key: ValueKey('about'),
        child: AboutTeamWidget(),
      ));
    } else {
      print("Not Found");
    }

    return pages;
  }
}
