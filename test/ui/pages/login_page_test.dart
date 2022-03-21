import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_archtecture/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterMock extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter = LoginPresenterMock();

  Future<void> loadPage(WidgetTester tester) async {
    // presenter = LoginPresenterMock();
    // LoginPage utiliza componentes do material design, por isso, é necessário
    //encapsulá-lo dentro de um MaterialApp
    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);
    // find.descendant = irá procurar todos os filhos de um componente qualquer
    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);
    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));
  });
}
