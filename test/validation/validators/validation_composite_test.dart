import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_archtecture/validation/protocols/field_validation.dart';
import 'package:clean_archtecture/validation/validators/validators.dart';

class FieldValidationMock extends Mock implements FieldValidation {}

void main() {
  late ValidationComposite sut;
  late FieldValidationMock validation1;
  late FieldValidationMock validation2;
  late FieldValidationMock validation3;

  void mockValidation1(String? error) {
    when(() => validation1.validate(any())).thenReturn(error);
  }

  void mockValidation2(String? error) {
    when(() => validation2.validate(any())).thenReturn(error);
  }

  void mockValidation3(String? error) {
    when(() => validation3.validate(any())).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationMock();
    when(() => validation1.field).thenReturn('other_field');
    mockValidation1(null);
    validation2 = FieldValidationMock();
    when(() => validation2.field).thenReturn('any_field');
    mockValidation2(null);
    validation3 = FieldValidationMock();
    when(() => validation3.field).thenReturn('any_field');
    mockValidation3(null);
    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validations returns null or empty', () {
    mockValidation2('');

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });

  test('Should return the first error', () {
    mockValidation1('error_1');
    mockValidation2('error_2');
    mockValidation3('error_3');

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, 'error_2');
  });
}
