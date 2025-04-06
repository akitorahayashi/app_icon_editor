import 'package:flutter/material.dart';
import 'package:app_icon_editor/view/app_icon_preview_screen.dart';

void main() {
  runApp(const AppIconEditorApp());
}

class AppIconEditorApp extends StatelessWidget {
  const AppIconEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Icon Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: const AppIconPreviewScreen(),
    );
  }
}
