import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_archtecture/domain/usecases/usecases.dart';

import 'package:clean_archtecture/data/http/http.dart';
import 'package:clean_archtecture/data/usecases/usecases.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientMock httpClient;
  late String url;

  setUp(() {
    httpClient = HttpClientMock();
    url = faker.internet.httpUrl();
    //sut = System Under Test
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    await sut.auth(params);
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': params.email,
        'password': params.password,
      },
    ));
  });
}
