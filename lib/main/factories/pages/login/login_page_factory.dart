import 'package:clean_archtecture/main/factories/factories.dart';
import 'package:clean_archtecture/ui/pages/pages.dart';
import 'package:flutter/material.dart';

Widget makeLoginPage() {
  return LoginPage(makeLoginPresenter());
}
