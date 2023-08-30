import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';
import 'package:storyconnect/Services/Beamer/beamer_locations.dart';
import 'package:storyconnect/theme.dart';

final routerDelegate = BeamerDelegate(
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      WriterLocations(),
    ],
  ),
);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        lazy: false,
        create: (_) => WritingRepository(),
        child: MaterialApp.router(
          theme: myTheme,
          routerDelegate: routerDelegate,
          routeInformationParser: BeamerParser(),
          backButtonDispatcher:
              BeamerBackButtonDispatcher(delegate: routerDelegate),
        ));
  }
}
