
class StateAddress {
  int id;
  String name;
  String abbreviation;

  StateAddress(int id, String name, String abbreviation) {
    this.id = id;
    this.name = name;
    this.abbreviation = abbreviation;
  }

  static StateAddress toModel(Map<String, dynamic> map) {
    return StateAddress(map["id"], map["name"], map["abbreviation"]);
  }

}