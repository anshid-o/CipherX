import 'package:cypher_x/app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1800, 900),
    minimumSize: Size(1800, 900),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
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
