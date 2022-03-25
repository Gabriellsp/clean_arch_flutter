import 'package:clean_archtecture/presentation/protocols/protocols.dart';

import 'package:clean_archtecture/validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite([
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ]);
}
