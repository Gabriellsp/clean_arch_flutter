import 'package:clean_archtecture/main/factories/factories.dart';
import 'package:clean_archtecture/presentation/presenters/presenters.dart';
import 'package:clean_archtecture/ui/pages/pages.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
  );
}
