import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gtc_chat/home_page.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MaterialApp(home: HomePage()));
}
