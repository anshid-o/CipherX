import 'package:cypher_x/app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: flutterNesTheme(
          brightness: Brightness.dark, primaryColor: Colors.lime),
      home: HomePage(),
    );
  }
}
