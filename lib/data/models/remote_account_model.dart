import 'package:clean_archtecture/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(
    this.accessToken,
  );

  AccountEntity toEntity() => AccountEntity(accessToken);

  factory RemoteAccountModel.fromJson(Map json) =>
      RemoteAccountModel(json['accessToken']);
}
