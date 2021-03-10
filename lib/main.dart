import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbscap/Forms/Home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QB Scap',
      theme: ThemeData(
          splashFactory: InkRipple.splashFactory,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white),
      darkTheme:
          ThemeData.dark().copyWith(splashFactory: InkRipple.splashFactory),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
