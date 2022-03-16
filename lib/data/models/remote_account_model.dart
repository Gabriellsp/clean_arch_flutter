import 'package:clean_archtecture/data/http/http.dart';
import 'package:clean_archtecture/domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(
    this.accessToken,
  );

  AccountEntity toEntity() => AccountEntity(accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(json['accessToken']);
  }
}
