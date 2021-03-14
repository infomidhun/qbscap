import 'package:qbscap/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qbscap/Forms/Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => History()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    context.watch<History>().alloc();

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
