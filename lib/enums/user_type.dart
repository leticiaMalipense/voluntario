
enum UserType {
  INDIVIDUAL,
  COMPANY
}

class UserTypeHelper {

  static String getValue(UserType type){
    switch(type){
      case UserType.INDIVIDUAL:
        return "INDIVIDUAL";
      case UserType.COMPANY:
        return "COMPANY";
      default:
        return "";
    }
  }

  static UserType getType(String value){
    switch(value){
      case "INDIVIDUAL":
        return  UserType.INDIVIDUAL;
      case "COMPANY":
        return UserType.COMPANY;
      default:
        return null;
    }
  }

}
