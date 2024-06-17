import 'package:provider/provider.dart';
import 'home/home_page.dart';
import 'package:flutter/material.dart';
import 'theme.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AlbumProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      home: const HomePage(),
    );
  }
}
