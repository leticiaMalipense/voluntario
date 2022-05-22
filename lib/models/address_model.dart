
class AddressModel {
  String cep;
  String stateName;
  int stateId;
  String city;
  String street;
  String neighborhood;
  int number;
  String complement;

  static AddressModel toModel(Map<String, dynamic> map) {
    AddressModel model = AddressModel();

    model.city = map["city"];
    model.street = map["street"];
    model.neighborhood = map["neighborhood"];
    model.stateName = map["stateName"];
    model.stateId = map["stateId"];
    model.complement = map["complement"];

    return model;
  }
}