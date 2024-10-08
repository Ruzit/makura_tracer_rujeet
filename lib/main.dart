import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:makura_tracer/core/services/firebase_api.dart';
import 'package:makura_tracer/features/map/presentation/view/map_page.dart';
import 'package:makura_tracer/firebase_options.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseApi().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Makura Tracer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MapPage(),
      ),
    );
  }
}
