import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Repositories/core_repository.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';
import 'package:storyconnect/Services/Beamer/login_locations.dart';
import 'package:storyconnect/Services/Beamer/profile_locations.dart';
import 'package:storyconnect/Services/Beamer/reader_locations.dart';
import 'package:storyconnect/Services/Beamer/writer_locations.dart';
import 'package:storyconnect/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final routerDelegate = BeamerDelegate(
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      LoginLocations(),
      WriterLocations(),
      ProfileLocations(),
      ReaderLocations(),
    ],
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            lazy: false,
            create: (_) => WritingRepository(),
          ),
          RepositoryProvider(
            lazy: false,
            create: (_) => ReadingRepository(),
          ),
          RepositoryProvider(create: (_) => CoreRepository())
        ],
        child: MaterialApp.router(
          theme: lightTheme,
          darkTheme: darkTheme,
          routerDelegate: routerDelegate,
          routeInformationParser: BeamerParser(),
          backButtonDispatcher:
              BeamerBackButtonDispatcher(delegate: routerDelegate),
        ));
  }
}
