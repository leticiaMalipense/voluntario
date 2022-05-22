

class TokenModel {
  int id;
  String name;
  String document;
  String type;
  String token;

  static TokenModel toModel(Map<String, dynamic> map) {
    TokenModel tokenModel = TokenModel();

    tokenModel.id = map["id"];
    tokenModel.name = map["name"];
    tokenModel.document = map["document"];
    tokenModel.type = map["type"];
    tokenModel.token = map["token"];
    return tokenModel;
  }
}