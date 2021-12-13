import 'package:flutter/material.dart';
import 'package:medicino/Authentication/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Medicino',
      // theme: ThemeData.dark(),
      // theme: ThemeData(
      //   textTheme: const TextTheme(
      //     bodyText1: TextStyle(),
      //     bodyText2: TextStyle(),
      //   ).apply(
      //     bodyColor: Colors.white,
      //     displayColor: Colors.red,
      //   ),
      // ),

      debugShowCheckedModeBanner: false,
      home: Signin(),
    );
  }
}
