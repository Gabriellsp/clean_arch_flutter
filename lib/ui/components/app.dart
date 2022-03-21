import 'package:flutter/material.dart';

import 'package:clean_archtecture/ui/pages/pages.dart';
import 'package:flutter/services.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

    return MaterialApp(
      title: 'Clean Archtecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        backgroundColor: Colors.white,
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: primaryColorDark),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: primaryColorLight,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          alignLabelWithHint: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
        ),
        focusColor: primaryColorLight,
      ),
      home: const LoginPage(null),
    );
  }
}
