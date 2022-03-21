import 'package:clean_archtecture/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import 'package:clean_archtecture/ui/components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? presenter;

  const LoginPage(this.presenter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(),
            const Headline1(text: 'Login'),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                  child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: presenter!.validateEmail,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        icon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      obscureText: true,
                      onChanged: presenter!.validatePassword,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: null,
                    child: Text(
                      'Entrar'.toUpperCase(),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.person),
                    label: const Text('Criar conta'),
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
