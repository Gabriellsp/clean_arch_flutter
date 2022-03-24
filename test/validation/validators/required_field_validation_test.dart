import 'package:clean_archtecture/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  late RequiredFieldValidation? sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Should return null if value is not empty', () {
    final error = sut!.validate('any_value');
    expect(error, null);
  });

  test('Should return null if value is not empty', () {
    final error = sut!.validate('');
    expect(error, 'Campo obrigatório');
  });

  test('Should return null if value is not empty', () {
    final error = sut!.validate(null);
    expect(error, 'Campo obrigatório');
  });
}
