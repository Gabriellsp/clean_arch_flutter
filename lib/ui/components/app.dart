import 'package:flutter/material.dart';

import 'package:clean_archtecture/ui/pages/pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Clean Archtecture',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
