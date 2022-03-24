import 'dart:async';

import 'package:clean_archtecture/domain/helpers/helpers.dart';
import 'package:clean_archtecture/domain/usecases/usecases.dart';

import 'package:clean_archtecture/presentation/protocols/protocols.dart';

class LoginState {
  late String? email = null;
  late String? password = null;
  late String? emailError = null;
  late String? passwordError = null;
  late String? mainError = null;
  bool? get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
  bool? isLoading = false;
}

class StreamLoginPresenter {
  final Validation validation;
  final Authentication authentication;
  StreamController<LoginState>? _controller = StreamController<
      LoginState>.broadcast(); // broadcast vc tem mais de um listener ouvindo esse controlador
  final _state = LoginState();

  StreamLoginPresenter({
    required this.validation,
    required this.authentication,
  });

  Stream<String?>? get emailErrorStream => _controller?.stream
      .map((state) => state.emailError)
      .distinct(); // o distinct não deixa emitir dois valores iguais na stream

  Stream<String?>? get passwordErrorStream =>
      _controller?.stream.map((state) => state.passwordError).distinct();

  Stream<String?>? get mainErrorStream =>
      _controller?.stream.map((state) => state.mainError).distinct();

  Stream<bool?>? get isFormValidStream =>
      _controller?.stream.map((state) => state.isFormValid).distinct();

  Stream<bool?>? get isLoadingStream =>
      _controller?.stream.map((state) => state.isLoading).distinct();

  void _update() => _controller?.add(_state);

  void validateEmail(String? email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email!);
    _update();
  }

  void validatePassword(String? password) {
    _state.password = password;
    _state.passwordError =
        validation.validate(field: 'password', value: password!);
    _update();
  }

  Future<void> auth() async {
    _state.isLoading = true;
    _update();
    try {
      await authentication.auth(
        AuthenticationParams(
          email: _state.email!,
          password: _state.password!,
        ),
      );
    } on DomainError catch (error) {
      _state.mainError = error.description;
    }

    _state.isLoading = false;
    _update();
  }

  void dispose() {
    _controller?.close();
    _controller = null;
  }
}
