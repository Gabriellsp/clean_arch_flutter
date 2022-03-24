import 'dart:async';

import 'package:clean_archtecture/presentation/protocols/protocols.dart';

class LoginState {
  late String? emailError;
  late String? passwordError;
  bool? get isFormValid => false;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<
      LoginState>.broadcast(); // broadcast vc tem mais de um listener ouvindo esse controlador

  final _state = LoginState();

  Stream<String?> get emailErrorStream => _controller.stream
      .map((state) => state.emailError)
      .distinct(); // o distinct não deixa emitir dois valores iguais na stream

  Stream<String?> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  Stream<bool?> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({required this.validation});

  void _update() => _controller.add(_state);

  void validateEmail(String? email) {
    _state.emailError = validation.validate(field: 'email', value: email!);
    _update();
  }

  void validatePassword(String? password) {
    _state.passwordError =
        validation.validate(field: 'password', value: password!);
    _update();
  }
}
