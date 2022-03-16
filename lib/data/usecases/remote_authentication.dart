import 'dart:convert';

import 'package:clean_archtecture/data/http/http.dart';
import 'package:clean_archtecture/data/models/remote_account_model.dart';
import 'package:clean_archtecture/domain/entities/account_entity.dart';
import 'package:clean_archtecture/domain/helpers/helpers.dart';
import 'package:clean_archtecture/domain/usecases/usecases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<AccountEntity>? auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toMap();
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: 'post',
        body: body,
      );
      return RemoteAccountModel.fromJson(httpResponse!).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
        email: params.email,
        password: params.password,
      );

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory RemoteAuthenticationParams.fromMap(Map<String, dynamic> map) {
    return RemoteAuthenticationParams(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoteAuthenticationParams.fromJson(String source) =>
      RemoteAuthenticationParams.fromMap(json.decode(source));
}
