import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_archtecture/presentation/presenters/presenters.dart';
import 'package:clean_archtecture/presentation/protocols/protocols.dart';

class ValidationMock extends Mock implements Validation {}

void main() {
  late StreamLoginPresenter? sut;
  late ValidationMock? validation;
  late String? email;
  late String? password;

  When mockValidationCall(String? field) => when(() => validation!.validate(
      field: field ?? any(named: 'field'), value: any(named: 'value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationMock();
    sut = StreamLoginPresenter(validation: validation!);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut!.validateEmail(email);
    verify(() => validation!.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');
    // expectAsync1 = ele executa apenas se sua função for verdadeira e se executar apenas 1 vez
    sut!.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut!.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validateEmail(email);
    sut!.validateEmail(email);
  });

  test('Should emit null if validation succeeds - email', () {
    sut!.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut!.isFormValidStream
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
    sut!.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut!.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validatePassword(password);
    sut!.validatePassword(password);
  });

  test('Should emit null if validation succeeds - password', () {
    sut!.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut!.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut!.validatePassword(password);
    sut!.validatePassword(password);
  });
}
