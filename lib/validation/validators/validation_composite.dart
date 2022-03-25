import 'package:clean_archtecture/presentation/protocols/protocols.dart';
import 'package:clean_archtecture/validation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;
  ValidationComposite(this.validations);
  @override
  String? validate({required String? field, required String? value}) {
    String? error = null;
    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);
      if (error?.isNotEmpty == true) break;
    }
    return error;
  }
}
