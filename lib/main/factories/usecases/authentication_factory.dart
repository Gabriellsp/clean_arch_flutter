import 'package:clean_archtecture/data/usecases/usecases.dart';
import 'package:clean_archtecture/domain/usecases/authentication.dart';
import 'package:clean_archtecture/main/factories/factories.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('login'),
  );
}
