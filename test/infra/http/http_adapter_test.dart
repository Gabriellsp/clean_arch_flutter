import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);
  Future<void> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    await client.post(Uri.parse(url), headers: headers, body: jsonBody);
  }
}

class ClientMock extends Mock implements Client {}

void main() {
  late ClientMock client;
  late HttpAdapter sut;
  late String url;
  late Uri uri;

  setUp(() {
    client = ClientMock();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
    when(() => client.post(uri,
            headers: any(named: 'headers'), body: any(named: 'body')))
        .thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));
  });

  group('post', () {
    test('Should call post with correct values', () async {
      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(() => client.post(
            uri,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
            body: '{"any_key":"any_value"}',
          ));
    });

    test('Should call post without body', () async {
      await sut.request(
        url: url,
        method: 'post',
      );

      verify(() => client.post(
            uri,
            headers: any(named: 'headers'),
          ));
    });
  });
}
