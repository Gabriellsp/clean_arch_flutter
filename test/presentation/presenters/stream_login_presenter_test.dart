import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_archtecture/domain/usecases/usecases.dart';
import 'package:clean_archtecture/domain/entities/account_entity.dart';
import 'package:clean_archtecture/domain/helpers/helpers.dart';

import 'package:clean_archtecture/presentation/presenters/presenters.dart';
import 'package:clean_archtecture/presentation/protocols/protocols.dart';

class ValidationMock extends Mock implements Validation {}

class AuthenticationMock extends Mock implements Authentication {}

void main() {
  late StreamLoginPresenter? sut;
  late AuthenticationMock? authentication;
  late ValidationMock? validation;
  late String? email;
  late String? password;

  When mockValidationCall(String? field) => when(() => validation!.validate(
      field: field ?? any(named: 'field'), value: any(named: 'value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  When mockAuthenticationCall() => when(() => authentication!.auth(any()));

  void mockAuthentication() {
    mockAuthenticationCall()
        .thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationMock();
    authentication = AuthenticationMock();
    sut = StreamLoginPresenter(
      validation: validation!,
      authentication: authentication!,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
  });

  test('Should call Validation with correct email', () {
    sut!.validateEmail(email);
    verify(() => validation!.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');
    // expectAsync1 = ele executa apenas se sua função for verdadeira e se executar apenas 1 vez
    sut!.emailErrorStream!
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut!.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validateEmail(email);
    sut!.validateEmail(email);
  });

  test('Should emit null if validation succeeds - email', () {
    sut!.emailErrorStream!.listen(expectAsync1((error) => expect(error, null)));
    sut!.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validateEmail(email);
    sut!.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut!.validatePassword(password);
    verify(() => validation!.validate(field: 'password', value: password))
        .called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: 'error');
    // expectAsync1 = ele executa apenas se sua função for verdadeira e se executar apenas 1 vez
    sut!.passwordErrorStream!
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut!.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validatePassword(password);
    sut!.validatePassword(password);
  });

  test('Should emit null if validation succeeds - password', () {
    sut!.passwordErrorStream!
        .listen(expectAsync1((error) => expect(error, null)));
    sut!.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validatePassword(password);
    sut!.validatePassword(password);
  });

  test('Should emit email error with password succeeds', () {
    mockValidation(field: 'email', value: 'error');

    sut!.emailErrorStream!
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut!.passwordErrorStream!
        .listen(expectAsync1((error) => expect(error, null)));
    sut!.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validateEmail(email);
    sut!.validatePassword(password);
  });

  test('Should emit null with email and password succeeds', () async {
    sut!.emailErrorStream!.listen(expectAsync1((error) => expect(error, null)));
    sut!.passwordErrorStream!
        .listen(expectAsync1((error) => expect(error, null)));
    expectLater(sut!.isFormValidStream, emitsInOrder([false, true]));

    sut!.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut!.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut!.validateEmail(email);
    sut!.validatePassword(password);

    await sut!.auth();

    verify(() => authentication!
        .auth(AuthenticationParams(email: email!, password: password!)));
  });

  test('Should emit correct events on Authentication success', () async {
    sut!.validateEmail(email);
    sut!.validatePassword(password);

    expectLater(sut!.isLoadingStream, emitsInOrder([true, false]));

    await sut!.auth();
  });

  test('Should emit correct events on InvalidCredentialsErros', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut!.validateEmail(email);
    sut!.validatePassword(password);

    expectLater(sut!.isLoadingStream, emits(false));
    sut!.mainErrorStream!.listen(
        expectAsync1((error) => expect(error, 'Credenciais inválidas')));

    await sut!.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut!.validateEmail(email);
    sut!.validatePassword(password);

    expectLater(sut!.isLoadingStream, emits(false));
    sut!.mainErrorStream!.listen(expectAsync1((error) =>
        expect(error, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut!.auth();
  });

  test('Should not emit after dispose', () async {
    expectLater(sut!.emailErrorStream, neverEmits(null));
    sut!.dispose();
    sut!.validateEmail(email);
  });
}
